class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://gitlab.com/randy408/libspng/uploads/3d980bac86c51368f40af2f1ac79a057/libspng-0.5.0.tar.xz"
  sha256 "220a653802559943ae43fd48f03ba6ff3935a5243766d9ee5ff905240d4399a7"

  bottle do
    cellar :any
    sha256 "c0a033d31ecd804286f453b78ed915479c645f3cdc9582eb9292304945ffc8c3" => :mojave
    sha256 "733decd9549a1c7926bd962e58d5affee6042fea46a7668cc4d2f7f5920e1062" => :high_sierra
    sha256 "c98ef1891f03bc2a0c3c6649bec9a4d07a4fbc52a10e2b853dfcbd7ced6b9446" => :sierra
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
