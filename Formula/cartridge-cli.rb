class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.5",
      revision: "98ecccc288394427568b58bd4784f95ddc86d646"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d876183704a5cc0f4e9eebbf97a52be2ffb8101688e929ed682f08b3628499d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdefa01d22ba6973cc64d8162b5547d2be96570dfd11d99d6786eb9fbc4db6a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb2583bb469c0b774b2d6848a3e463401b866f116267292df8563a08b7d28b91"
    sha256 cellar: :any_skip_relocation, ventura:        "5a0533ada6cf2d876d110afab917a6ec9055191b796c88b73ae601d4df120cb5"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a1da7c93e22640a0641759bee7b117b390b4415d7b327ac238303a628080df"
    sha256 cellar: :any_skip_relocation, big_sur:        "4faefbe923c6f2e3d9b414c6f5eceb0007c0109940746a748fe79d16d166a132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b6c485ec13f8e2f799012ea03eba345e09ceb8df72df3f21d8ff6855ab93ef"
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
