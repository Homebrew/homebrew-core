class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://gitlab.com/randy408/libspng/uploads/3d980bac86c51368f40af2f1ac79a057/libspng-0.5.0.tar.xz"
  sha256 "220a653802559943ae43fd48f03ba6ff3935a5243766d9ee5ff905240d4399a7"

  bottle do
    cellar :any
    sha256 "05d22f51215ebc9b77e5155d7b7d209d50eefaa7b4d287634bd6d09922f05679" => :catalina
    sha256 "c01b660f652c77917df28b6b651c00458822c0ccf1b1947be4c6f334bf414944" => :mojave
    sha256 "c3da9d3ca4b66eec6a0ed1c5510444653935976d942b678bbeeeff9c3ef522c9" => :high_sierra
    sha256 "0ca546539595f727222b1c5e21cd24735d2213f29e3ab3d344f269f2f11a084b" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"
    output = shell_output("./example #{fixture}")
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\ncompression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end
