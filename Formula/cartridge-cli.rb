class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.6.0",
      revision: "6d409e4a0139238441420f7fc58453cb21488035"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "875c19e2fcb15d07b7ce167d6657af81e7137c5b80c77b33533792a307e06dce"
    sha256 cellar: :any_skip_relocation, catalina: "361e9cfc5f12e0980f3ac052603c9dca0c52e62ed4c70e01b3b07faf554b5924"
    sha256 cellar: :any_skip_relocation, mojave:   "8e2ec16a6bed6b6762530ebf34ee9084b33417f56f975a5270e35b115bca8107"
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
