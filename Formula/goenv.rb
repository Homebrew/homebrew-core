class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.6.tar.gz"
  sha256 "ba4882cf34dd44b0d5349f0a2931aa672478a77fa64023874fc2cd1a52a15792"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0e5d50704c497080a8b7ba300d12e5086ac2e248a69aa0b25fe2148a8ae1cd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0e5d50704c497080a8b7ba300d12e5086ac2e248a69aa0b25fe2148a8ae1cd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0e5d50704c497080a8b7ba300d12e5086ac2e248a69aa0b25fe2148a8ae1cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "82a9a7d404efa1f809605b3f5cc4ad99c55b0819a7088d00c8294effee7de3a9"
    sha256 cellar: :any_skip_relocation, monterey:       "82a9a7d404efa1f809605b3f5cc4ad99c55b0819a7088d00c8294effee7de3a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "82a9a7d404efa1f809605b3f5cc4ad99c55b0819a7088d00c8294effee7de3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e5d50704c497080a8b7ba300d12e5086ac2e248a69aa0b25fe2148a8ae1cd4"
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
