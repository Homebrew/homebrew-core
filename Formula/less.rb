class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-581.2.tar.gz"
  sha256 "ce34b47caf20a99740672bf560fc48d5d663c5e78e67bc254e616b9537d5d83b"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "95b4a2d6ccbcadca7bb39d9b86997d92945c56d7ba421ba5a24fad5e456aa012"
    sha256 cellar: :any, big_sur:       "2732e9582beafecf6084067ec39d547e2c6259dee8884c6dbb0ab083a9d32168"
    sha256 cellar: :any, catalina:      "908e9936ade67b803ba14ab6c85ffae16a804baae405ffcf017f327828c8d096"
    sha256 cellar: :any, mojave:        "55c3665b219f38f3a4bea7be9961d6c13e513cebd935408fda11bd6d84582b74"
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  def install
    system "make", "-f", "Makefile.aut", "dist" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
