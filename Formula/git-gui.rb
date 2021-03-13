class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.2.tar.xz"
  sha256 "41f7d90c71f9476cd387673fcb10ce09ccbed67332436a4cc58d7af32c355faa"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7866be93d8bc333f4fdba78ddda67a79a653b9021904f57a0ffc2eca408374d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "d299a40adc41a52ae30fccb8a4a73eebb9efa4b7f33c035e0b7f081ceb6bfac2"
    sha256 cellar: :any_skip_relocation, catalina:      "32b306f6559b8d3bfd2a1a2d7379acaf159c78a05cedc5b05c656595be21da2c"
    sha256 cellar: :any_skip_relocation, mojave:        "c0cf97bb3086ff6c7bfe925fbc15a660df9cd5ddc8c9800fce9302f6a0a5fba0"
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
