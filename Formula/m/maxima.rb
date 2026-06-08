class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 6

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e84b73979be1ecdd48af8acc379c8bc8d0bacfa4545857e7b2f84b7676bd10c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31aec83e96c849c949bbec840295e05a7f3dda8abe99e8a274c366c6b45d51a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "792ae044d65c8d7ed8044f35f2dfb7ca40e513e8cdfa9e91cc418a7d8af418fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d494ff28bead16b6bb43a667af15c1c9e7f1c490ed2dc64e8fdf204e014854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14e5e0dbdb972d36f48ec88582cc2768937b560f0768ff5a1e37950d2e7ceacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7408dd51b0179e10bfcc3c17b34f7e4bff8d2e7c2665f68434c9dfb78c4c3b"
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
