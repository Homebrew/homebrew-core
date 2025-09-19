class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.5/librevenge-0.0.5.tar.xz"
  sha256 "106d0c44bb6408b1348b9e0465666fa83b816177665a22cd017e886c1aaeeb34"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url "https://sourceforge.net/projects/libwpd/rss?path=/librevenge"
    regex(%r{url=.*?/librevenge[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "78c667da8c03fcda8b994dc180cc75e03cfd36c014f7b904b02a6f602d1f62dc"
    sha256 cellar: :any,                 arm64_sequoia:  "8c3a4c2ed4af0c16cffd5ac758a8dc3ccec9ea4f0e620ef9ddc401d506660515"
    sha256 cellar: :any,                 arm64_sonoma:   "0b4b3683933059632de09508e6d49273a7908cf93a729a2899518eeb2313ce5e"
    sha256 cellar: :any,                 arm64_ventura:  "113a4ee5774cf6c3a58e4ea202b3ff39ef2d25f0500236b202d0d164b302dc8c"
    sha256 cellar: :any,                 arm64_monterey: "39b114185ac16a714309ebfbeb02264016a9b72b75d1a1da33bdd0cba42d8ba6"
    sha256 cellar: :any,                 arm64_big_sur:  "e46e76a7ca6022277a6d8be2d267ff2496434992b91c149dd59e70a79b31c9cc"
    sha256 cellar: :any,                 sonoma:         "fe9b919007a458bb9adc9a5507f9a7a0ffbdc572c60927a0933fe7b7978c2ca7"
    sha256 cellar: :any,                 ventura:        "cf1a9383368a1c4a7c54c978815fcef64a1e2c64e66183a45e12be72ad8f3ab4"
    sha256 cellar: :any,                 monterey:       "636e3e8ce0e3e775e9ccfaec62c22cd1987db4c50f56e5671cc3eb4bcb002b23"
    sha256 cellar: :any,                 big_sur:        "64e6213d3ef01f6ace0b4e4f46e9b4098ddabe735eafb07a213a21454c47bca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a66a66d364db186d07e4b705c177b5773e1ee99f19cc00843c26a1baf73a8da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11fd00b1110acb46392ccc91a6fbb54261834a53e256e3d48d6c268e71d7c4b5"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "./configure", "--without-docs",
                          "--disable-static",
                          "--disable-werror",
                          "--disable-tests",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
