class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.48.1.tar.xz"
  sha256 "1c5d545f5dc1eb51e95d2c50d98fdf88b1a36ba1fa30e9ae5d5385c6024f82ad"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c4fc0d527b5e26bc53ab370310e72cfbc9b4841542946fe276f880ec13cba15"
  end

  depends_on "tcl-tk@8"

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk@8"].opt_bin
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
