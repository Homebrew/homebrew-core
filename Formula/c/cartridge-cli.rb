class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.8",
      revision: "31207d89f1e0bddf0215093ce2b606d7df85fe23"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d5b35b0cb5dc7ce9e3e3bd60c083a8c17b3c0c2d5eb4800af522b7a299233b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c921e17a5db76f56ce52f4384822a99b5ac0950c58334731a44335692d37cdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9adc336d8ddd111526e5bbc4916c512ef13923e0db6094b5267675af4590061"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d0b22811e547db64d5be885c4672ff187aef5897adbb75ef14f1f1649df8cb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b74e0eb9a9440a9e6f23145ef48a04fafc7305d624c8672d7147c408a97d4d2"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce8332a10b4b62cb306411aa431c05c58424ae51da6360424efc9a6968b5289"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c8de6bb4ab7cb418e73e0eb9ced3eae9a3632e80c08b8acdc6ae49bc410b01"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5e24430a57e2448121e8a45ad38eb6cb05737b6183e115ba11875d95dc52fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db3f800a529f26992b0fb0d72dedb9c357485b273a85d60815f29217f9970ba"
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
