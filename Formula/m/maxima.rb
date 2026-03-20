class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "223f783f75d7f88aa60c66fdb347469e28beac9b190f77470531604321e66a70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "014cf36f994218dc8fe95d2d8ae0655124e835bcbfbbaa8ea0b0c7633f983ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a7e58a90cc730f4684905b2dfeaa9971fd6b503632442381b474f4f374fb98"
    sha256 cellar: :any_skip_relocation, sonoma:        "123679820f9abcca2334836fe84cd0ff04c952f8b5eb34998bfdf66ddf966776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1072e21438c4c9e2f94c55bdd06b4c5a1a96030ce04e0ddc186b4e65f5e1d5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "520ba335f58a018624bf8883355745da2cd2b7e4019d05a6ec81ae1cb197b336"
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
