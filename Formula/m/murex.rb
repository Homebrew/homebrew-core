class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.4.9500.tar.gz"
  sha256 "6840c83da6dcb9a2a109982de0bf36ed9182f25e829d3e5dc0a4e0be5a1c4baa"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a55d51722656065778528af0e7f39b33c203c6affe0c0efaf902567a2084e3ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c9af5c085b5123acc799975bd6217c93f79c410dee0de2c6e68a88cdb25f4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeed4c93f16e8ced663409ae444910da8627d8a84052bb3ba8b7db470a541687"
    sha256 cellar: :any_skip_relocation, ventura:        "5f6a71edcc57b5f3ae1c385313ddbc058b9c8382aae74cd5969b0fe5e5dc6c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f9dea76ea6a84ee45f1c14bc6e3ad1b6222edcbbfa3a78f4e5caeda4bcdb2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "10f75b14d47521c295b18b60e52a36aea499d734bcb861c6442f79195374f623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f3d15670143c2acd54a9368b3f12e342465821455af38fa961135dd078cc23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
