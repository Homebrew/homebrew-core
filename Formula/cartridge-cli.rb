class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.10.0",
      revision: "2b87a1b1d6159d8fe8ed52bca58a00365e29cbde"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea51b9bb88158e82edb5b079a07915993a1ef0a07e810aa87acacfa46a32031d"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e92881071540ce28124b70532542bc5769c7aee816c97d263fb59cbc9fc535a"
    sha256 cellar: :any_skip_relocation, catalina:      "883b771de9dcb40281867c74f8a187fab3024940725736f0e0f21897ec865159"
    sha256 cellar: :any_skip_relocation, mojave:        "14bfb8dedf6118be65ce692359f96213145d34963f17fd7a46a929ff5df64e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c17b33ca0210967a88b1dc0a9c835d60e5d7ab1ddebe872ca51bdcd288a4ae"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    system "mage", "build"
    bin.install "cartridge"
    system bin/"cartridge", "gen", "completion"

    bash_completion.install "completion/bash/cartridge"
    zsh_completion.install "completion/zsh/_cartridge"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
