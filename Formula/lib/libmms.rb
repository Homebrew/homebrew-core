class Libmms < Formula
  desc "Library for parsing mms:// and mmsh:// network streams"
  homepage "https://sourceforge.net/projects/libmms/"
  url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  sha256 "3c05e05aebcbfcc044d9e8c2d4646cd8359be39a3f0ba8ce4e72a9094bee704f"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "aa6cb8c3240b6fbcc6e58fc69c3e117ff0a1c1c1a3eaa22b6374d13a91b2c2fa"
    sha256 cellar: :any,                 arm64_sequoia:  "3bb78466780c6a9b24cf16bb0c333e5e62e8aca7b7f27a1175dcce96d369dd92"
    sha256 cellar: :any,                 arm64_sonoma:   "256fd337db7087fc76bbd4b119df0621377c33b231eb11e609680955b65b19dc"
    sha256 cellar: :any,                 arm64_ventura:  "c341b6abc297d20d408019a94893e6f9bb2859c34d3e100926bac2550a2d41b0"
    sha256 cellar: :any,                 arm64_monterey: "cc895b39e7d44f9ddf9f09319b35a89e093e345dc28ee6f786529012a4ab86e2"
    sha256 cellar: :any,                 arm64_big_sur:  "23e8d5a9591a26c8f167f346cfd2c789f1241458338eb4ce5f90e9c440aab7f0"
    sha256 cellar: :any,                 sonoma:         "311410a29d2c125854503091ab13680dee5abd4420e6b3dd26a595e8b07b3456"
    sha256 cellar: :any,                 ventura:        "d838b0cc94af92dba3197e2d55658eeb6758c04e089fe3eea9ace446b465b2b8"
    sha256 cellar: :any,                 monterey:       "83b2b74920729e81a9225065aaf75949add189c2ee5557d2cab410d45965d501"
    sha256 cellar: :any,                 big_sur:        "49439ac923403c34c9fb042ed167a8830d424cd113303d66ed2d70f7aeb23840"
    sha256 cellar: :any,                 catalina:       "15016ca7557449405339f310e6feeccbc04094702fcc7d4be53909fc738b05f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ed7a66b304d548c1426e5b0fa507a7cd3f06923aa13d8d14876b9e94e81146ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf0654cdf09b4ca5c749e75d8920ff2eddee195e31a468c64bee07f74571b29"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
