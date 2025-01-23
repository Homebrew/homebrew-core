class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 17

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77e3c3c951fd4935ec4f19d529397346ef7f8b7787db79ef4dc9816ce553c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a3118bb883163ba63bbb5e056fddf8cb635dcef8d15f1619faf94e75ebdd84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db9c6dc3927eae408fd1ba0852a9f58d7a99b0832d416f17cd81264252a0675"
    sha256 cellar: :any_skip_relocation, ventura:       "0c71e39c485e1d52593e53a71ad98938a2b2365a6dd6917dd1eea75696201785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab0cc9795927ac3b3d4649fcaef07104cc2fc81d4e600c7eaf305adddf5c161"
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
