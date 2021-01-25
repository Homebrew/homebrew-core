class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.5.0",
      revision: "98f361c2a44bc003ff2838fc9b20bd5fa2b4a876"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "eef624f8c6e2e685a6ebc1701b49379649d18aa286aca8c0850ee81a9bad3e87" => :big_sur
    sha256 "d35447ff5b2f525b2efb04374efb5192b500793476c1ed6350c695c0555d8fc2" => :catalina
    sha256 "8491a54e283498d46b9959e668d57933b5737ec1a40672f44522cc044f9248a5" => :mojave
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
