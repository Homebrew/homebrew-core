class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.0",
      revision: "b4ed1a2a2ddf05bd6b6dd059fb68f3c1e4ff9366"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a5095dbf74396e4339f08b8834e08206e14b4f53e800bcf141f67ab7bae070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d11608d43883c32ac2f82445ae404fb4e470a12d21252f9e455e61d6d0494d43"
    sha256 cellar: :any_skip_relocation, monterey:       "ae0d202ae2e87ff301d40837a011c434a288845946ac4c501f386dc84d192fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "75404c41ea00d59d5b34e940bd66d9bc5001a681ef1f0f5d4cbc6f7303166812"
    sha256 cellar: :any_skip_relocation, catalina:       "fc8a1f7bf9d7d2d4a6240890dbe005ddce1c9a82a8de96de712e30de902f51b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed9fb0337aaa5754fb1048f87158f45b4579532fda57c3a9379f349cc79f2444"
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
