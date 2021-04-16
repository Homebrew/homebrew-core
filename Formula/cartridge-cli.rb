class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.8.0",
      revision: "9fa5c75b1798b7a389cd920940815ddb5806681a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f30ae36e39757a217274b9b0aebb2a30510764e49fe89c315f421db9b212d7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef6c940e204492247c90baf942931a681e0fd47c1e3c1613a0646956214eb6a4"
    sha256 cellar: :any_skip_relocation, catalina:      "48bebb906f118f7e1c98c53f0bbe47ffd00227f427c2c21de08a0e1a497a813a"
    sha256 cellar: :any_skip_relocation, mojave:        "1728106730b9c39fb5fbd3b61c88cee9824e32e4a8537057ca09c13c3312117f"
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
