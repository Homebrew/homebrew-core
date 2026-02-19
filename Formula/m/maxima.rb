class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce16dd9f385c679fa7b7290d96be885337a173797da1779e78edb9bb6641e749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff552e00409a275c9bc766f581b245fae1f409507090501c5470fb2d58cbdcac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8b7dddb8efe7da03521c4fc4b32f3fca6e5305fb23d102caf26ec879f1757b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c6794c25e9c978bb85227ce99998fc12ab58a0cc814bfd3b5b60c29b429ef7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d976c665b1bf76a757a56e8f572280e24d9a8403fd5f406ef81ea13fa3d740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124f138cdd9b5cf7f4995b245a97616cc9ea7131002c5c2286124d9341c71379"
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
