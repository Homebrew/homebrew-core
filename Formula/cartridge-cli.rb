class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.2",
      revision: "53e6a5be9a611323401a3d98d2dd380da4f672f9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e2918f3c30d8811da3644ac41c92c4f0a0bdff7739c21232526df276be4904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b836ae371bfc82ef13758fdf9ee23cbcffacf1ac7d444f17eab55217f35d27a7"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc467f57f326e341110c3420ff2ffe762ee39a332751b064c9179662bf9d9f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "79f45c0b4aacd8e0b42b64183b5d32a30c40b28b12d397bfe5b86e35a6f271e9"
    sha256 cellar: :any_skip_relocation, catalina:       "ee6513172636ebb5af17b642b1c587688be1d4b3a2322f049427a0a615c0f1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acd7594d7c01690eec96bf176b1d27930d669310ee54e368b3cc8f023a28ac8b"
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
