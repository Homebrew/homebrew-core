class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.3",
      revision: "004186a0188f90e4481f026f09bb9c929acb37e6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad496023cec1b5b5b6c27c6de41e04f9f02dc466f030b5f96d6eeb0289113af2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cf68c050cabac6274ca0f3666b6291153826da65eed14baf845bba5a1394ce1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d0004cd07a66b9b398058ec91315e8b91ba5fd5aa8cbca61a65cc61c724f4f1"
    sha256 cellar: :any_skip_relocation, ventura:        "c7fba36befa79022b162ace8e7727fa086a5cb0d43e070fc859d327ecb17a6da"
    sha256 cellar: :any_skip_relocation, monterey:       "341ec6f97803a2a550578c0b980b1c505b5d6ce77521d59c23645f7c9c4551be"
    sha256 cellar: :any_skip_relocation, big_sur:        "46bea2c3aed541d608e409636da7137b3eaee5fb7cbdead213a05817b0f03225"
    sha256 cellar: :any_skip_relocation, catalina:       "719e57ffcac394ebc18c636a6d485748b2bfc55cfd5f4ac9eacd6d74dea70ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e26974e597652f3905e0aca0b27a5988891b7a7d8eb36123c717a95ebbc120"
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
