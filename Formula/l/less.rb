class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-679.tar.gz"
  sha256 "9b68820c34fa8a0af6b0e01b74f0298bcdd40a0489c61649b47058908a153d78"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c167ef66f66ea608f4d8c2a62daf90c54d209c492ca36373b6c4b21889c2124"
    sha256 cellar: :any,                 arm64_sonoma:  "c8d271ef876c5591a67460068226247fb597f1b802b2616c85ba43d6b6b842e4"
    sha256 cellar: :any,                 arm64_ventura: "bd30a0f7e3b09305d58c8b943341d19480292bfc0316a60c731ef95e7d943170"
    sha256 cellar: :any,                 sonoma:        "6cb7136c30fc4695d509bb6fa174245f54fad777bdfc1cdd2d42e23708408128"
    sha256 cellar: :any,                 ventura:       "56563af2638138d67278c41a1cdfc42a4ffaa2c85c7d89f3ec350a5a2b4d3f05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c4d002465a313676bc41faf9720028b932b49f83429bbaff52c1d94d62238a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68b1ad54d048a50a5d738a1c38ad43c7a1789b9f8b5168d77fa8dc8ab21aa17"
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
