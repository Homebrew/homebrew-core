class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.31.1.tar.xz"
  sha256 "9f61417a44d5b954a5012b6f34e526a3336dcf5dd720e2bb7ada92ad8b3d6680"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6941b6984b73e4f89c9635a6113a0401461821febd431116dd06cf4971ec469"
    sha256 cellar: :any_skip_relocation, big_sur:       "430d3e73a3d07bb170c1bd3eb3db3a5cbb283e1fd72671e9607f00cce23982eb"
    sha256 cellar: :any_skip_relocation, catalina:      "603bf37ef37e46f4ec88855d44bd61a227299638dda5690c367b55c733ba3cf7"
    sha256 cellar: :any_skip_relocation, mojave:        "59df29678a0fa2c9546ee91ec1c8d4061ad3ae7436ecb4beef92fecd6c62de41"
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
