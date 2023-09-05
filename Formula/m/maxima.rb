class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ba55d2d214c731309b58560944b28b7cf043997fe493adf556e3e0b4d019488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfc7894163cdc2e125aa89f53b2a6c330fc9acbb8c4dab6c998775d8e9a19086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cadbefe6c8e41a6d8997699c1f4fb5b53c41da6cf352ac4dcde9b46f95ebe425"
    sha256 cellar: :any_skip_relocation, ventura:        "36dc290cc4d60f59901a1b30dc76392321fb88b44b47e4679c547d7489905715"
    sha256 cellar: :any_skip_relocation, monterey:       "e57c346adf9d2ae832012971365ac1dfa61ee19ceffa2a38f08b9f9436522d0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "df0a0d42348e4db03474ea1099818e4d9a4acf334a5294dffd098d714ec1dc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8cd8d31e6e3885cf39a078bd9edb2ae3d4271f45bd75952a90cd862b59ceaa"
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
