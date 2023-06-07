class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-633.tar.gz"
  sha256 "2f201d64b828b88af36dfe6cfdba3e0819ece2e446ebe6224813209aaefed04f"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18200ddc7610677aa54a248eeeeae3e3589b5dc47680a111d17d9c0aee4ebaf0"
    sha256 cellar: :any,                 arm64_monterey: "b3b72d134f0d1815b9ccd5d5b56ce1f2b610bc6049351a4d37f7f33ef3241948"
    sha256 cellar: :any,                 arm64_big_sur:  "2d48868d85ad94041b6ddd5f9f1d1f51616ad63ee5488714c48e2bc18b339c0f"
    sha256 cellar: :any,                 ventura:        "6bac7585569ea82cf336fda7696865dd7d9bfb13d988d6a93a1fb9e68e79e4d6"
    sha256 cellar: :any,                 monterey:       "5ed83764c8d4af1cb98ff2f30f1341d95945d19c71316e21013b73a8920a0eb5"
    sha256 cellar: :any,                 big_sur:        "9d8193d570bf6c90b88c352e49c82a5eec076d2764a73712b74b52e851d564c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75223e3c687bffe70af4ae6fea19e327dc573a4d6e7df625bf670238d228ad45"
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
    system "#{bin}/lesskey", "-V"
  end
end
