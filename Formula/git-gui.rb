class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.31.0.tar.xz"
  sha256 "e8f162cbdb3283e13cd7388d864ed23485f1b046a19e969f12ed2685fb789a40"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a3bd222c3edf48528d77e7807d3b4723abd8ff3243361aafe964212c813ade0"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d8803003a68cff4fe56dc8244b491af4d26c9ac9df76136fa826462925aeed7"
    sha256 cellar: :any_skip_relocation, catalina:      "60cb252e34234b9749fa9c757ad9b92a02ccd163896e36d90e99892d3d9407b0"
    sha256 cellar: :any_skip_relocation, mojave:        "e82720dcc0caeee5c7f8569d446969fe0a4cfd918cfc5c8a994259b32817cd26"
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
