class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://www.kernel.org/pub/software/scm/git/git-2.25.0.tar.xz"
  sha256 "c060291a3ffb43d7c99f4aa5c4d37d3751cf6bca683e7344ea407ea504d9a8d0"
  head "https://github.com/git/git.git", :shallow => false

  depends_on "git"
  depends_on "tcl-tk"

  def install
    ENV["V"] = "1" # build verbosely
    tcl_bin = Formula["tcl-tk"].opt_bin
    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{libexec}/git-core
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
    # Git looks for git-foo binaries in $(git --exec-path), i.e.
    # $CELLAR/git/$VERSION/libexec/git-core and in $PATH.
    # If we only keep them in the cellar directory they will not be found.
    # The easiest solution to this problem is to move the binaries
    # from libexec to bin to ensure that git finds them when running e.g.
    # `git gui` from the command line.
    bin.install libexec/"git-core/git-gui"
    bin.install libexec/"git-core/git-gui--askpass"
    bin.install libexec/"git-core/git-citool"
    # Check that the libexec directories are empty so that we don't
    # forget to correctly install any newly added tools.
    (libexec/"git-core").rmdir
    libexec.rmdir
  end

  test do
    system bin/"git-gui", "--version"
  end
end
