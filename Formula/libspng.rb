class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.6.0.tar.gz"
  sha256 "81fea8d8a2e0c8aa51769605ad0e49a682e88697c6b5b60105f5c3806efaa3a3"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "ec4ab7110d00fffa808a99bdbbc3a2c6715de32b37f26c2815f1b5cfd2811f94" => :catalina
    sha256 "f4f385dc73f061ffa6c90e1a6083c0c855ec3c6c91f844e241e52ce9cc016669" => :mojave
    sha256 "825c72b4148b1d39003ba95a0b10bf7cf020c6b4144858eaaa97ce6dbdd6bace" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"

    # example.c returns 73 ("no text chunk") for the test.png fixture
    # this will probably be changed in v0.7,
    # see: https://github.com/randy408/libspng/issues/109
    output = shell_output("./example #{fixture}", 73)
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\n" \
                 "compression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end
