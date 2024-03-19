class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.10",
      revision: "76044114f412b1fa15e353f84e7de1f0c3d98566"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96ea68ef8a79d2a020a90f63a2efdd31440527ed40df66ec3c483ed7b71f0c24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64aa1aaf3d62cd83230124e28dfbd8fef47d4e3ecbca2d190e41221958f8676e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c9dded4c5e9c205315cd246f0d9eaba1bead7a81e324394aaff2bbb52c7ac9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f615ce5d50907d82d9f727916587d3f516568838edfd39e678329d2b0a60fd76"
    sha256 cellar: :any_skip_relocation, ventura:        "786f099256517380717b6a9186fc64b0cf626760ec52ea110572dd3a3aa6755a"
    sha256 cellar: :any_skip_relocation, monterey:       "9982e408326cd5109c3482bd2abdfa22620e4ba43f93824bfc9de6e39764b25f"
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
