class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.35.tar.gz"
  sha256 "527495035ff5471270b9b035b209422d0a4d8d58ff6ce8f5298b6a83c361d19f"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9918ad8dc823d14873f47c40a70614a43e95444dd4b165ea153ae35014b05637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9918ad8dc823d14873f47c40a70614a43e95444dd4b165ea153ae35014b05637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9918ad8dc823d14873f47c40a70614a43e95444dd4b165ea153ae35014b05637"
    sha256 cellar: :any_skip_relocation, sonoma:        "190805e3e98d8de8eea374c2c08678f3a3a5c57e8d17dd48c1c574cdcd95b5fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9918ad8dc823d14873f47c40a70614a43e95444dd4b165ea153ae35014b05637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9918ad8dc823d14873f47c40a70614a43e95444dd4b165ea153ae35014b05637"
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
