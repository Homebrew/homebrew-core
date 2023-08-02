class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/2.1.3.tar.gz"
  sha256 "e35f5cd7fe1f5283c6888ea99888509110d1707ca390ceca484ba34712cd8eab"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c99d552c5e8a93c0debb06e4dfddb03a9c1d3c9413cc002b10e1ca481f668af2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c99d552c5e8a93c0debb06e4dfddb03a9c1d3c9413cc002b10e1ca481f668af2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c99d552c5e8a93c0debb06e4dfddb03a9c1d3c9413cc002b10e1ca481f668af2"
    sha256 cellar: :any_skip_relocation, ventura:        "3b8b0898591a85efd88d531ee8a206adcd7d1cb5dc90de41583ce0147633a8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "3b8b0898591a85efd88d531ee8a206adcd7d1cb5dc90de41583ce0147633a8ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b8b0898591a85efd88d531ee8a206adcd7d1cb5dc90de41583ce0147633a8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e77d0a0743f4030301816bae38ee061f2e410882cd5cb9ef69527496338735"
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
