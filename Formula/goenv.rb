class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.8.tar.gz"
  sha256 "026ebcecdd6dc97f1d2127ce3baf918f4ff18bc09e099a3a98b19169b7c8bb33"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470af02781dd02980789dbdc264d2cace8a30f6eb77d975ac403112e3c1e3e86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470af02781dd02980789dbdc264d2cace8a30f6eb77d975ac403112e3c1e3e86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "470af02781dd02980789dbdc264d2cace8a30f6eb77d975ac403112e3c1e3e86"
    sha256 cellar: :any_skip_relocation, ventura:        "926c2f84f61eb72c11f99b1b1e034bc1f9a116c6bd5bfcc67185321e18b72b76"
    sha256 cellar: :any_skip_relocation, monterey:       "926c2f84f61eb72c11f99b1b1e034bc1f9a116c6bd5bfcc67185321e18b72b76"
    sha256 cellar: :any_skip_relocation, big_sur:        "926c2f84f61eb72c11f99b1b1e034bc1f9a116c6bd5bfcc67185321e18b72b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470af02781dd02980789dbdc264d2cace8a30f6eb77d975ac403112e3c1e3e86"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
