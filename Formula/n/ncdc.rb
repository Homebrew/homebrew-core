class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.25.tar.gz"
  sha256 "b9be58e7dbe677f2ac1c472f6e76fad618a65e2f8bf1c7b9d3d97bc169feb740"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ncdc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "63721a456161299dcfacead5df5422fa0f6d45029024f3f1fba5d3d237035fdb"
    sha256 cellar: :any,                 arm64_sequoia: "276d92cc9c94019497087d4a45b42523bd85363cf7c7d2963f23279151c29915"
    sha256 cellar: :any,                 arm64_sonoma:  "e9d454ad3206ac918f5384ad18427f63310ad8b20d74876ac9ce2f9addff463f"
    sha256 cellar: :any,                 sonoma:        "cf9a24752fe13d74322c81911ad76a056308e9f5ae265fe5f2ffa6c62669316b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024989a066148e269c9de57a247aeacaa3d653df8906ad4c501442e544070721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906546b6c289d880cec610ced06c0527e5b4f49d4595dcd2cf1b6984f08b42ce"
  end

  head do
    url "https://g.blicky.net/ncdc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "ncurses"
  depends_on "sqlite"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ncdc", "-v"
  end
end
