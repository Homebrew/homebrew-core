class Grace < Formula
  desc "WYSIWYG 2D plotting tool for X11"
  homepage "https://plasma-gate.weizmann.ac.il/Grace/"
  url "https://deb.debian.org/debian/pool/main/g/grace/grace_5.1.25.orig.tar.gz"
  sha256 "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac"
  license "GPL-2.0-only"
  revision 5

  livecheck do
    url "https://deb.debian.org/debian/pool/main/g/grace/"
    regex(/href=.*?grace[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "f930e961b7d6dd7d104e8f786247a044113ff0b7e58be16061d5a04ff4365188"
    sha256 arm64_sequoia:  "61fed352c42b6211971448d69512dd09726ef1daa1fab3f52d3ceeec048ad6d9"
    sha256 arm64_sonoma:   "502d3e9a6cf08eb5080c2adc8aabc1833bc65cfd26bc9053cd3b4c0742e763a9"
    sha256 arm64_ventura:  "25e56b21ed182a4cac2db983a01316c859d9191b0d31bce5050bc0e83d55eb04"
    sha256 arm64_monterey: "26ff1421ae2de1ce2319b4584d4e09b9262b1ed126d8c767d44a87009b8ee219"
    sha256 arm64_big_sur:  "1ba31e5d4e056187e182e8c46a71e6bc4dbb8b6e35d6f314fb64aa3136a93f43"
    sha256 sonoma:         "ba106c9e707cb707da47ecf3183bff8b0a00aae131d82f4a72e60768ac1a5bb7"
    sha256 ventura:        "cd2e7a9db645ec5cbd45c591c865840d24e19ce94b7a067cadf7147cc5f85b75"
    sha256 monterey:       "4f30899270663be69c5a6ee832c0ef7b19baf3a422f7fc6d06ef6fd5d69e0892"
    sha256 big_sur:        "8c5c9770e21706084537da65b5a4c0ab95f0dee9036b716ed3987496aabd1b4f"
    sha256 catalina:       "f7e7b6cd2ec94d293b711dfb8c20cba1e000d89a791c7e3596b4806c73250432"
    sha256 arm64_linux:    "6490f0fba875ea85cd6ee5006dd7bc75ac2dacf08bb16d7aca56fbf5e46a291f"
    sha256 x86_64_linux:   "1d60f284e17b5b7b40e51c41070ca4eeacf9bda3c9e75065e53c40921de9472d"
  end

  depends_on "fftw"
  depends_on "jpeg-turbo"
  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  def install
    ENV.O1 # https://github.com/Homebrew/homebrew/issues/27840#issuecomment-38536704

    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1200
      ENV.append_to_cflags "-Wno-implicit-function-declaration -Wno-implicit-int"
    end

    system "./configure", "--enable-grace-home=#{prefix}",
                          "--disable-pdfdrv",
                          *std_configure_args
    system "make", "install"
    share.install "fonts", "examples"
    man1.install Dir["doc/*.1"]
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"gracebat", share/"examples/test.dat"
    assert_equal "12/31/1999 23:59:59.999",
                 shell_output("#{bin}/convcal -i iso -o us 1999-12-31T23:59:59.999").chomp
  end
end
