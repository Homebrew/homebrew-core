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
    sha256 cellar: :any,                 arm64_tahoe:   "5743781d81d4fadfdcd4d5d760dd9b4a91af6f802503e2c5743bfd596b916281"
    sha256 cellar: :any,                 arm64_sequoia: "4d18bc67d0060378c9e8aa8160c9cec8ab87ac473ab219052aff65e0cc8399ef"
    sha256 cellar: :any,                 arm64_sonoma:  "8311ceb65f6aabdb8b81404455abcc1a54e4e08eefd01956dc3f76f13c1189a0"
    sha256 cellar: :any,                 arm64_ventura: "94810e9e763b6f15b2cabd1579ab2995582493f9f9ebac57e56f40e8f8d59cae"
    sha256 cellar: :any,                 sonoma:        "cf910ac39cc769044fdc4302f266f68f11b9eb03f73d4cd013c3c396753ba1f3"
    sha256 cellar: :any,                 ventura:       "a468507ac3e9724260be8ba7b32dfbf96d0a4daba19b21aef44040bbd1a3970f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "055e73d95ac9e947e3b9937a2d209b669bc014d06810243b5a74b5d7bcc11ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5dadf6576e959b0891b26599f60d6d3de70b5a05d1298ca534688e16cd4427e"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
