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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "facf55a083cd1ced9b8d830f69bc324721fec9fd04ae71c39c8cb86bd0e2d6e1"
    sha256 cellar: :any,                 arm64_sequoia: "58bd7e8c6ffaa76bb0b29e3412627f99910e7a8f71a779dd918155b2ee391591"
    sha256 cellar: :any,                 arm64_sonoma:  "4f454529bdd59fd1a61cb63c2c177d1c340c870b725270b511ffabfc71d4bdc2"
    sha256 cellar: :any,                 sonoma:        "a2eedb69f6bee6315ecd3bc943aede16981a396afd64a0485f89745393d36ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afcdbbc6e5a973ec55ff425bef158b615e3848aec37c5451b2164aba68064823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aaa3a093a95ef3606ae834193919e16384b5161ded94cae54fb5d005fc3c269"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
