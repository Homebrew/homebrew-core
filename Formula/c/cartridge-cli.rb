class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.11",
      revision: "4ba052189c0b9776126a7905fe5160622695ba14"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1da4ba6199182f45661e3d4f1b7f661065fded1a44f5b9c7f2bd53858517bbc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "564016fbad96724c65e5320bda7c65e51e68436a1514fff4d190a5601af09950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6307ba8f516bba08f1a533d8852469d958ea0c94aa5140799daa920b3f7fcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb58963de38235b5d37bd6c22242a4299d39f0e2f7693d3854dfc9f2205db8ec"
    sha256 cellar: :any_skip_relocation, ventura:        "e5877f540b0301b30d3fa2ce38f8b8bfee1f4aa65a221c9e1df881b4325046a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f1899de05bc51b2ba2bbdbc1831e480098beeef9dad84bf96a5c404bac2a7040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba7e1475451f2afebf0f3581ba06b750703883dfe42ab50c3ff195ec15b1dc4"
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
