class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1ecc3e1ac4a811ed770411402050828ca1c17318235f6c4d6373cec36908263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723048538dfb0664d761ac639ed19fa7d5d834a765fe2601eff7cbb60db81e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759447271ca783415bbea231345878183595a547eae587df1a4415d176b02023"
    sha256 cellar: :any_skip_relocation, sonoma:        "05b1f0ed16bf223cec3b15b1ccc24619e8e5f1252fb1ec61471a6530cabd5f16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5981e4bb3dccc17bd263ec24beb64ca1cfe81a340c094269175d15073c5712ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f18c565ca824fdd4a7f2b00e931fb6bb8a8b9595025fb6c559568a9b67fa532"
  end

  depends_on "gawk" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
