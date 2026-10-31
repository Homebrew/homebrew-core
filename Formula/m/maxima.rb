class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.50.0-source/maxima-5.50.0.tar.gz"
  sha256 "0bc4b5e11fe153ef20b24a3a816b668ece5378cc738fa24ca426b62fd6d8fc37"
  license "GPL-2.0-only"
  revision 3
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e240785d9f40b667d0dd06145ab4101ebae90a79f68295785cf4c2ada787b4b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b25abed4d6ca7622bd311fd486f95c939af1a1e0a6158808024ee6a5cc503d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e2ebd59edcd730e469ba4b3c9522efdfe6707b0cfa968b8b45046faf6dc615f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aea1cfcb64cf51317b863d60946c9c2ad1ed9b4fabefffd4cd9119ce3fa95ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "56d929dd97b8cc238ead9835357fed2d576fce3b5ee14244b542bb9e9d71740d"
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

  deny_network_access!

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{formula_opt_bin("sbcl")}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
