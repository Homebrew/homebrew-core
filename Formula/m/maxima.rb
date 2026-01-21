class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d7bf2a990266ea2fde31474e26edf4395fefab4ebce73325c95dea132f7405c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f589e4793c3aa8d0e4466dcfc753a85e226edaf655ff7c519daaa85481affd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a9f3691840fda7fe562835c7e5a298a24c4c79e343d0528fed33ef1096269d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71d150124659cd5f91994def7fa8a5d811f4986c3334d5a240cdac67d043b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "641025dcff494229554d2407eceb5741eab795f9edcbe7f3fcbcbe863942ac5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c7062b3a7eecf64f6334f3543b74196a96c8aa8816b882a44b3746dc3ea51c6"
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
