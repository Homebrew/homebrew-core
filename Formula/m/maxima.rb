class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 9

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e6287f483d4244fc7adf19046a1b142998d59a9452a5252e9a741ab22820aca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255033acc8941556bb57de7a7a81f87709ce11a60842fe6e047238bed6052a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ba4af5f83e587df5180931ccabedf39e4da5f7de6cdc62352dc7f6df8c950a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ece358d0c7f90abfdf598f6e4f111257032237a750477b5daeef1efe675ee6d1"
    sha256 cellar: :any_skip_relocation, ventura:        "f6581615d4c71dc66b568cb02137cf9b57bf24be4a6027f6ec458cd83a6ff2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "85e99fc3f1777429b85fa1055c674d070980a9b183038e9b4664f221e6502498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973d892af58487e90e612183d5d45dfbd732aa55760285d8846069af99931e59"
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
