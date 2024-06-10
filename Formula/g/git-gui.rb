class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.45.2.tar.xz"
  sha256 "51bfe87eb1c02fed1484051875365eeab229831d30d0cec5d89a14f9e40e9adb"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8150389f89d20c15f00ad0357e361401d7519a5cf9742d91316ed13b54657199"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8150389f89d20c15f00ad0357e361401d7519a5cf9742d91316ed13b54657199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8150389f89d20c15f00ad0357e361401d7519a5cf9742d91316ed13b54657199"
    sha256 cellar: :any_skip_relocation, sonoma:         "8150389f89d20c15f00ad0357e361401d7519a5cf9742d91316ed13b54657199"
    sha256 cellar: :any_skip_relocation, ventura:        "8150389f89d20c15f00ad0357e361401d7519a5cf9742d91316ed13b54657199"
    sha256 cellar: :any_skip_relocation, monterey:       "8150389f89d20c15f00ad0357e361401d7519a5cf9742d91316ed13b54657199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e9f706127e30b1275c6c319d4f8feb08a7ab91756c9a472868f3bbbb80a842"
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
