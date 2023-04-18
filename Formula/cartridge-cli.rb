class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.4",
      revision: "cbf864a31cb58c2343c2af5d534ec0ee002b1bd9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef70017fe9e3a084f3c5f2af4b3b6eb102002dc93bffa45e3bae2da01c901a8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1017a1c92fbacbf876cdf465cdf0aa5bda7b4b79131a941b03b3a5d033b9aebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e55f08dcc9d6a98fd3f7f2b08ee600d445a183b1e834ff3b7628b77a9fbf3f5e"
    sha256 cellar: :any_skip_relocation, ventura:        "17c1d0e920e5aa412914b0c13939443353cb72fc4ca75fc077fae159330dcdb0"
    sha256 cellar: :any_skip_relocation, monterey:       "171e9d150fc555b1d66c6076e003777b017db0126022dd51c20aabb9dba94146"
    sha256 cellar: :any_skip_relocation, big_sur:        "407a96da1aacadc05a4b0b859c19b38a3f92cb735d2d73d75fa05a05bcf22e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb9a10454cd357d55e15ff914cf29ad82e14c5a6e0d4decf8d4a5a614c69785"
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
