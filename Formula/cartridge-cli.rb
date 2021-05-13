class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.9.1",
      revision: "5770f5e62e71271c216e59e81934fda8b58e0039"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0b30d2bd3369af7d5fff3fa8061dd1bc67a4c484455bbbae8ed5ad6a5255bc36"
    sha256 cellar: :any_skip_relocation, big_sur:       "6dd9045fed44ff760cc1e6e6a8b52e619a10e0cc319309ae07e02953ed531e58"
    sha256 cellar: :any_skip_relocation, catalina:      "a353f686032c6282a9ae100e525c7615e7f9b95ab43300b3e8149dcb5a03b51d"
    sha256 cellar: :any_skip_relocation, mojave:        "6a340c6c330b52a776bf0a67ada752453f9470738a268adc79611b5289239905"
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
