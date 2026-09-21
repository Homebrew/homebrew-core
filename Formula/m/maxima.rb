class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.50.0-source/maxima-5.50.0.tar.gz"
  sha256 "0bc4b5e11fe153ef20b24a3a816b668ece5378cc738fa24ca426b62fd6d8fc37"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e21ced6f50881c7cb66aa29d85279bb06689ec295d08e735018bbc8ef6f90cf2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67d0a6145e01ed4f9d94792fc90826641d5ad59151f24cce48db6fcaffac848a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff57a72b5f565b5b62ac3043faebf1c227e5aa568730dc401ebbc30cce65cd12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bfc90b68b99f3c2dee490474b010a8d5bf0708e43086fd5f21f225295d971e97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "868cbcdd2a4901aad14136bde1dbaf8e8e1dac1da46aea2c87facb2c6240486e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "19f0d117134933ce44fcf44c903c7a30d53f7b987599b73b231174649aea5724"
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
                          "--with-sbcl=#{formula_opt_bin("sbcl")}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
