class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-661.tar.gz"
  sha256 "2b5f0167216e3ef0ffcb0c31c374e287eb035e4e223d5dae315c2783b6e738ed"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8595f05fe334627e7645ef3c3b06dc82e33fe8df63ce750d56f06beadff26ac1"
    sha256 cellar: :any,                 arm64_sonoma:   "cfb63b0a54db503b382df1eb92658b09e9e3234e25e8dc6973dedd1026e57c4e"
    sha256 cellar: :any,                 arm64_ventura:  "8f013221c467b8a71d8c19251139f46cb727173adef7e11a1071be0c705d267e"
    sha256 cellar: :any,                 arm64_monterey: "b21ce2f938836916b41daec8a906f64c9cf27b14cdc4ea4fe900a9e6dddc87dc"
    sha256 cellar: :any,                 sonoma:         "d02a9931e1d951074b1cd9c3ca54f974e67a0153c78764f913246712c188dd2a"
    sha256 cellar: :any,                 ventura:        "ee6f804370faa6b2b3f40db2080a291685c142bd2f7207c18bb77770cc71f726"
    sha256 cellar: :any,                 monterey:       "791d4cd683fabf7f9b1342baee2b07f7ec40a67c3bc6d6be21ca69860026738c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee1f4afb1837a82ed5d16f7a547c3e542c0da2fef96fc8632ec3bc6b25665649"
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
