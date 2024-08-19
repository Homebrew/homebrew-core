class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 12

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4985122399ad9567afa2d3009a4840555ea45aac3e496f5a461a6b2b67af085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8875a9370620eeda820b578155bd5bc62ab209357424a7df1e662557b7de89ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d54b2bf9b85024ad3d9771df8a7e5332d1fe4163d02e296f93017305fd59994"
    sha256 cellar: :any_skip_relocation, sonoma:         "455464ed0219067e3b919bb887df3b5c7b044bd7efd053f1628398a7edbc9a44"
    sha256 cellar: :any_skip_relocation, ventura:        "f16aa73fcd45da27f4b7903c9cfd5420f5e8c26445b0da55a8871954f6753219"
    sha256 cellar: :any_skip_relocation, monterey:       "5231eceaf972080662fc4e8a75a33e71a8d2bb212b09746b101d90845f125323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2571ae260b0a458d29edef16f676c2d6750acde36b9046040eb06dd280387fe"
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
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
