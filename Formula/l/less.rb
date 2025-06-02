class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-678.tar.gz"
  sha256 "4c085364f3028290d34647df27f56018c365dc4c0092ab7de74ed8fe89014fe7"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "502b8720691e823180290da162df33d6a3ee3276d32feb267c7e7dfa3b577668"
    sha256 cellar: :any,                 arm64_sonoma:  "3bbfb91b9a141230356b458272fe22205d6df4b6bf93029ecc295d3ec3df2adf"
    sha256 cellar: :any,                 arm64_ventura: "451515a2c9a3004ed57982a65210e534fbf17ee35af14df5832b781386ec171f"
    sha256 cellar: :any,                 sonoma:        "f912635990a5ae7ea078abc98ca51ade4ea8aa9091713f9e3bcf3739274ea174"
    sha256 cellar: :any,                 ventura:       "3ebf4828bee4254a689cd89251ac7fcf73cbc6c34eb1ced8ffdd9e4cec96eb2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8edfc61f568168f8e20c92ef83966f6d64f04d8723e36ec574072f1106fc6614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e65477589dd717159c9fa72dd9911fb5bdc492729639dec1e2c63dd5170be9"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system bin/"lesskey", "-V"
  end
end
