class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://www.kernel.org/pub/software/scm/git/git-2.25.2.tar.xz"
  sha256 "9b937103e048e2d3bf964d4132a0e7edccc2583d4ef30bc8a516f93a76de7123"
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "6586362ef6a2ce3ccb02de4ca4865054271f5be7779b07c470d48d70c958d0c2" => :catalina
    sha256 "6586362ef6a2ce3ccb02de4ca4865054271f5be7779b07c470d48d70c958d0c2" => :mojave
    sha256 "6586362ef6a2ce3ccb02de4ca4865054271f5be7779b07c470d48d70c958d0c2" => :high_sierra
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
