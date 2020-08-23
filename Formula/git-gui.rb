class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.28.0.tar.xz"
  sha256 "dfa5d1a253aa451465478fe45c6a40ab8605b340fdb4c4e80b16d7f87708439d"
  license "GPL-2.0"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "8cb98030e7d73a57d5584d67e7dabcf349ab188ad754bee2f04671ce5dc1ca5d" => :catalina
    sha256 "904291f8245394daad2a2bd875d377939d45503237db2ddc0edbf81c2a63d039" => :mojave
    sha256 "904291f8245394daad2a2bd875d377939d45503237db2ddc0edbf81c2a63d039" => :high_sierra
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
