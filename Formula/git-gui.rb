class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://www.kernel.org/pub/software/scm/git/git-2.25.1.tar.xz"
  sha256 "222796cc6e3bf2f9fd765f8f097daa3c3999bb7865ac88a8c974d98182e29f26"
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "0db08843c0417ed918b2fcc28f4bf70bd0621f67b22f2c0c346b9f914af4999f" => :catalina
    sha256 "0db08843c0417ed918b2fcc28f4bf70bd0621f67b22f2c0c346b9f914af4999f" => :mojave
    sha256 "0db08843c0417ed918b2fcc28f4bf70bd0621f67b22f2c0c346b9f914af4999f" => :high_sierra
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
