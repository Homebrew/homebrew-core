class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.7.0",
      revision: "ac1c3c6a7a9893a92fd46ce08817eb5880d20f7d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ff39fd0b62f09cc676a6b01a18e7e18d8fe589e6e3408759d8cf486d60e212ae"
    sha256 cellar: :any_skip_relocation, catalina: "39c31066aad3af3418ac3bc631c9ca03c8944b8b1db83faa9161c297f18cf0e6"
    sha256 cellar: :any_skip_relocation, mojave:   "5736ad20783b9045904fcf187ecdb86689fe443bb1576dc7e8651fec538c8389"
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
