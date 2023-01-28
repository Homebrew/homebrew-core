class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 9

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22c47b19ca6d456890d991e52c76473e8fa8c457280619cd5ab747ecfc6d3983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04e1064642d37fd2e74384b6dea73ef7c6f16be79fcb0846ef51a125be6b7c15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd2cf7c9fe4d7de64df7b58dedd74e9b8db09a9d8ac0e31806e2713afd438e61"
    sha256 cellar: :any_skip_relocation, ventura:        "31529bd77f03ec89d779da2bb7358a9011e133f7ac3c832af2baf8aff7a227c1"
    sha256 cellar: :any_skip_relocation, monterey:       "3542fd101e5d7f591dc98fb9413442b1cc4ee3df8f69a91c5ab53a6af20eb1a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5dbd1a9fb984dd67ac763b590fbb7a36904e655ce037d106b270620f9bd9d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76b88e53b18c6bd3a653ece525fdcda55e262f6fe27d4c7dbb4fc33645c1dcf"
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
