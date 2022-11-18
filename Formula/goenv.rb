class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.4.tar.gz"
  sha256 "f516d7d00d483a0d328dd4156e65399c2c84e12625080c82eaef500b0211a515"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce0cde64ba99a0cf98cc07e92126a506ea38680e42c306cc6f888a6010c0803"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ce0cde64ba99a0cf98cc07e92126a506ea38680e42c306cc6f888a6010c0803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ce0cde64ba99a0cf98cc07e92126a506ea38680e42c306cc6f888a6010c0803"
    sha256 cellar: :any_skip_relocation, ventura:        "dee76e5bf5df3d39deed32510baa9e1420e1395df898551da1ad19189c12d922"
    sha256 cellar: :any_skip_relocation, monterey:       "dee76e5bf5df3d39deed32510baa9e1420e1395df898551da1ad19189c12d922"
    sha256 cellar: :any_skip_relocation, big_sur:        "dee76e5bf5df3d39deed32510baa9e1420e1395df898551da1ad19189c12d922"
    sha256 cellar: :any_skip_relocation, catalina:       "dee76e5bf5df3d39deed32510baa9e1420e1395df898551da1ad19189c12d922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce0cde64ba99a0cf98cc07e92126a506ea38680e42c306cc6f888a6010c0803"
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
