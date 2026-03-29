class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74d28224184ec701e4706e5a2fdd94fbc611d953d0493214787f5bf560318cbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a786865f0926fa8afff706100ec6b752bd5d0fb9c7ae6cd363f36faae2290c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5176702c5155255475eaca239df84cfc6f4e9109cbc026f5d0a55c1d0f87928f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e052a154e150c444af1df1d8dd34a5062d5732dbdef1642de12876830b2312d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933610065fab7e81de832297ca9f971ab336d869bef32331df901a31df862c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b360daf9cd088d52a88feb81f7f58aca9320180c3137e8776a8bf6b1ac07022"
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
