class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://www.kernel.org/pub/software/scm/git/git-2.26.2.tar.xz"
  sha256 "6d65132471df9e531807cb2746f8be317e22a343b9385bbe11c9ce7f0d2fc848"
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e335a0021d9b205c246b74815eceb5c94542db733cb2ae360e1d36c17062ad36" => :catalina
    sha256 "e335a0021d9b205c246b74815eceb5c94542db733cb2ae360e1d36c17062ad36" => :mojave
    sha256 "e335a0021d9b205c246b74815eceb5c94542db733cb2ae360e1d36c17062ad36" => :high_sierra
  end

  depends_on "tcl-tk"

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
