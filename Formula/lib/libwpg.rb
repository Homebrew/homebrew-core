class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "https://libwpg.sourceforge.net/"
  url "https://dev-www.libreoffice.org/src/libwpg-0.3.4.tar.xz"
  sha256 "b55fda9440d1e070630eb2487d8b8697cf412c214a27caee9df69cec7c004de3"
  license all_of: ["LGPL-2.1-only", "MPL-2.0"]

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libwpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2aaaa4050e20a26525852f0cfe451e805728c7b03597e883e088c7eb234eea89"
    sha256 cellar: :any,                 arm64_sequoia:  "a062020deb99f826a9d7db555d3205c8fb56f431d19e916f7b17319641b9a00a"
    sha256 cellar: :any,                 arm64_sonoma:   "d2b1e6eed68f342f9a97a9059d84880c33316fbc4efaa011562b852432e6dd11"
    sha256 cellar: :any,                 arm64_ventura:  "c31dc532929561dc728f03ac0ff1ab2aeef0c0428df51cc8be13a7ea05a0e16e"
    sha256 cellar: :any,                 arm64_monterey: "387b98747ca1ef188c562bc3ab88283920a9ec220666b4a49ce27de7fbcd5f5c"
    sha256 cellar: :any,                 arm64_big_sur:  "6849a8efcf3f1a1440cb7b929d5cd1053d5b7944f7bc5adcfa835a95951b0eb3"
    sha256 cellar: :any,                 sonoma:         "aacf3220cfb291ab3d957eef407bc743ed767e17a0b926fa542db7fd785add80"
    sha256 cellar: :any,                 ventura:        "58f2f9eca5ef6a1c769dd67aa64f8b4d90740d1c0493791c6f06b3c2ab06a1d5"
    sha256 cellar: :any,                 monterey:       "24d4e25ee9c2468c18d9a578ef7a46499f4e46f1d85316ef57ce128adee16f63"
    sha256 cellar: :any,                 big_sur:        "c97eced8c226e67a62e503b0edf54f4114c0b3ef6213765eacdef6ae719938d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0d08712e0baa978acef8431b8d295d02f82a3d50c7396034df4a3e17be1551c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c079bc2c2fc9c98e967d13ffa15b47ab25efc59ba66f731ce3758d1265017368"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    CPP
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpg-0.3",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpg-0.3", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end
