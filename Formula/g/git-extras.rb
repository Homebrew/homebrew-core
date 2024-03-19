class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/refs/tags/7.1.0.tar.gz"
  sha256 "e5c855361d2f1ec1be6ee601247153d9c8c04a221949b6ec3903b32fa736f542"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "056792c05a926101be794b3bba82fe69e29fc4425b90b9d35e626f661905aa34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "056792c05a926101be794b3bba82fe69e29fc4425b90b9d35e626f661905aa34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056792c05a926101be794b3bba82fe69e29fc4425b90b9d35e626f661905aa34"
    sha256 cellar: :any_skip_relocation, sonoma:         "056792c05a926101be794b3bba82fe69e29fc4425b90b9d35e626f661905aa34"
    sha256 cellar: :any_skip_relocation, ventura:        "056792c05a926101be794b3bba82fe69e29fc4425b90b9d35e626f661905aa34"
    sha256 cellar: :any_skip_relocation, monterey:       "056792c05a926101be794b3bba82fe69e29fc4425b90b9d35e626f661905aa34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2fe250aa7a848dc82c8fb443db5767c70abbc9ec45de4c0c0e938c620c5319"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-sync",
    because: "both install a `git-sync` binary"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zshrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end
