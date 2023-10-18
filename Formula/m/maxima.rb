class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb5dc985444a339c99ce8695652db3e8209dc5df386ad3592c4b9260c0fad7e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ef5b09bda289db4484ae474a7057cf39db8751a34f1558330d99b8d637ecba2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd213d81bfff5234c14188c692356d7bcebbf31e29ae32496b529f328d435d43"
    sha256 cellar: :any_skip_relocation, sonoma:         "9456d7b033ac8791dae1400e848e2b103a3563ca8b9ae8820c4da56cea1e7263"
    sha256 cellar: :any_skip_relocation, ventura:        "47b84eeaa50737c593fe452fef52f225ca4c5b1459d93892524c78f6062117cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ab764d181abb2ab61719264deaf7684807aad64cd608674cf81279d1e22ebdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5532b116893c3cffa70c7a20b95a9292d585b93cccb941870660c490a86f9f07"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
