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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da9c7baa77d649fccf3bc100bdc736527627d9e1a5fb68c0dddbe844c46fe0f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da9c7baa77d649fccf3bc100bdc736527627d9e1a5fb68c0dddbe844c46fe0f8"
    sha256 cellar: :any_skip_relocation, monterey:       "8921097535d8d179f22d3d7ac857d6eab45f335dc616d825bb04868743f66927"
    sha256 cellar: :any_skip_relocation, big_sur:        "8921097535d8d179f22d3d7ac857d6eab45f335dc616d825bb04868743f66927"
    sha256 cellar: :any_skip_relocation, catalina:       "8921097535d8d179f22d3d7ac857d6eab45f335dc616d825bb04868743f66927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da9c7baa77d649fccf3bc100bdc736527627d9e1a5fb68c0dddbe844c46fe0f8"
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
