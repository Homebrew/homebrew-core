class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 6

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd2cc1fc06b7b54fc6ab6c00282325c4f2054bf162b293a6c18c738777c5f0d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfff923877c52890ab0cc5a9a8b671199b61f2bad95126b4deb3925c8bde93ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "515133eb2083d64852b96f1075e0fc4a12928909dc8c0c1ea98c31d63b7eae02"
    sha256 cellar: :any_skip_relocation, ventura:        "d1d8319da8b8c3906b957cfb80e7b0ae8caf041cc75b74628eb6b9a30f76868c"
    sha256 cellar: :any_skip_relocation, monterey:       "70f9a4804b4d67b83849a5bb1284e5520f3771edc511f0198aa7de84d3ee3b98"
    sha256 cellar: :any_skip_relocation, big_sur:        "5addc9d9906d13dfe758033f85ccc9b14d72a937db5bcf5628591382e0cf86e2"
    sha256 cellar: :any_skip_relocation, catalina:       "8ae459a232b9c3adeedef61a04e94be8503d3aec3cfff1f6505284f6613831af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f57d9749569cc08a8abcd8efc1d7dc9b7180eb74aacdf0029448d2ea5b2a07f"
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
