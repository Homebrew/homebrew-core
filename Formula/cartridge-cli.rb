class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.7.2",
      revision: "fde10b1d11a254fc976c2430870a9dd3d0e7a0d1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d726d306acead966383758f2af402e827be3c17e99b24711e837d231abeb1f80"
    sha256 cellar: :any_skip_relocation, big_sur:       "7578f54ada7887305f5ee6f029772727ba833b6f18ffb0894b3577789601f04f"
    sha256 cellar: :any_skip_relocation, catalina:      "5629cd6cb9ffff7d3dadbf831ee080fed225aef654e6bd2c942d054705764e44"
    sha256 cellar: :any_skip_relocation, mojave:        "6ff720309c90b52ba1fd77edc46f31afbf430a25ec1e2b9cb762a57cded8c450"
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
