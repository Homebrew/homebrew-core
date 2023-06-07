class Libmms < Formula
  desc "Library for parsing mms:// and mmsh:// network streams"
  homepage "https://sourceforge.net/projects/libmms/"
  url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  sha256 "3c05e05aebcbfcc044d9e8c2d4646cd8359be39a3f0ba8ce4e72a9094bee704f"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "c341b6abc297d20d408019a94893e6f9bb2859c34d3e100926bac2550a2d41b0"
    sha256 cellar: :any,                 arm64_monterey: "cc895b39e7d44f9ddf9f09319b35a89e093e345dc28ee6f786529012a4ab86e2"
    sha256 cellar: :any,                 arm64_big_sur:  "23e8d5a9591a26c8f167f346cfd2c789f1241458338eb4ce5f90e9c440aab7f0"
    sha256 cellar: :any,                 ventura:        "d838b0cc94af92dba3197e2d55658eeb6758c04e089fe3eea9ace446b465b2b8"
    sha256 cellar: :any,                 monterey:       "83b2b74920729e81a9225065aaf75949add189c2ee5557d2cab410d45965d501"
    sha256 cellar: :any,                 big_sur:        "49439ac923403c34c9fb042ed167a8830d424cd113303d66ed2d70f7aeb23840"
    sha256 cellar: :any,                 catalina:       "15016ca7557449405339f310e6feeccbc04094702fcc7d4be53909fc738b05f4"
    sha256 cellar: :any,                 mojave:         "4ac527e54af063a3fa760b1e4d43b56dd51ade89cbb971ac9bea9dd3500dfc70"
    sha256 cellar: :any,                 high_sierra:    "adc24aaa1656c02f41b20b4453f6a2deda8f3597c919eed1ae8befb732fc920f"
    sha256 cellar: :any,                 sierra:         "5319927f799dd20effbfc9f8bb90ebc844b39852c433bf434ab6b36c11c36417"
    sha256 cellar: :any,                 el_capitan:     "61c4dd24598198386342dd9c700e218b6b83c82627efc781daa89acfaca96066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf0654cdf09b4ca5c749e75d8920ff2eddee195e31a468c64bee07f74571b29"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
