class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.0",
      revision: "b4ed1a2a2ddf05bd6b6dd059fb68f3c1e4ff9366"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adea02d0bb82c6edc65e55691de32065999ecf44869d9cd4cd22d6bb814ae9c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9566c82761596c0efea8b04685247671f48f4e0fad52730731dbdc5877f39e73"
    sha256 cellar: :any_skip_relocation, monterey:       "5261e98e5b065378a6a913efe99449ebba2949bf439c810cd20a99efc27ef706"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ac5137cb5498f7bc492b2fdf9aedf77b83ab1099aef9e848771f9fd7979db5d"
    sha256 cellar: :any_skip_relocation, catalina:       "ca6198294842f852154f96578c3b4895b7158aaf65b3280c5442a51709346660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac526e592b74c95030cb027997769a4c1760d416e0deb1691fd1f4e7e62a584"
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
