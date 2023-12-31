class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 6

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7887391f73e60b835e917d1eff1bdd6890606fc65126264051bceacaf802de9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1416532351b411f1da9361c7caf0c418c4e466a7f54573f457f63b5319afdcd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8026e62d48d83df90cb6541d666c62854965eea838d53ce0b4b659da7856db1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b77c9b9cf6e7e94ce423ee605d7873de128c0d1b171ba4e4257b9a382faa544f"
    sha256 cellar: :any_skip_relocation, ventura:        "8de82aa73233c06e00c5bbb59ef8e4f6e6018bde524a9875c68d3a5dfecec787"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6e2a04f0a7ab582a1966395c8f551ce69dfeac5ffcb8fcd40ca0143f4d820a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9159aeb5ee4a52c5934b26f8430b574d0681934b57ac3d40ceaea9f2692c510c"
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
