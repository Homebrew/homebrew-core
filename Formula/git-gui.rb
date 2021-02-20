class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.1.tar.xz"
  sha256 "f988a8a095089978dab2932af4edb22b4d7d67d67b81aaa1986fa29ef45d9467"
  license "GPL-2.0"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "077cfab7fc2855565f2151934ff0aad1ddc6706781416339337f69220af775fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "b595a7d9d3ec8943e3b1d5d4fdc6d9dd595906627b579cc1bfb93bab4a2c6592"
    sha256 cellar: :any_skip_relocation, catalina:      "832b657d86d8ebe0e84629a1a077585edeab05965600acf011f9fa2497c6ea50"
    sha256 cellar: :any_skip_relocation, mojave:        "7048eb17bd7ef63637234749a6e60d8c7fb7d275ffa7be88a29dacda866d7333"
  end

  depends_on "tcl-tk"

  # Patch to fix Homebrew/homebrew-core#68798.
  # Remove when the following PR has been merged
  # and included in a release:
  # https://github.com/git/git/pull/944
  patch do
    url "https://github.com/git/git/commit/1db62e44b7ec93b6654271ef34065b31496cd02e.patch?full_index=1"
    sha256 "0c7816ee9c8ddd7aa38aa29541c9138997650713bce67bdef501b1de0b50f539"
  end

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk"].opt_bin
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin/"git-gui", "--version"
  end
end
