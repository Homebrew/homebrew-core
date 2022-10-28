class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.1.tar.gz"
  sha256 "803de2cc61579eee87c164987415338c504bef0f81d782ed1b2b135bc462d508"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c907313711c6d59f30992102c9c7dd63edfb36c7d1bd5103e3545df13b89450c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c907313711c6d59f30992102c9c7dd63edfb36c7d1bd5103e3545df13b89450c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c907313711c6d59f30992102c9c7dd63edfb36c7d1bd5103e3545df13b89450c"
    sha256 cellar: :any_skip_relocation, monterey:       "cb6cb190a223d9e86c4a8ffbecad50adc1e1d567e4ee5054ed068aac62c997b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb6cb190a223d9e86c4a8ffbecad50adc1e1d567e4ee5054ed068aac62c997b3"
    sha256 cellar: :any_skip_relocation, catalina:       "cb6cb190a223d9e86c4a8ffbecad50adc1e1d567e4ee5054ed068aac62c997b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c907313711c6d59f30992102c9c7dd63edfb36c7d1bd5103e3545df13b89450c"
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
