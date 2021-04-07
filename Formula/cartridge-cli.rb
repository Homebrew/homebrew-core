class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.8.0",
      revision: "9fa5c75b1798b7a389cd920940815ddb5806681a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2fdfa02042d6f8c9577662d71f03a3b10788da8bf5453a3571ffc1627489c145"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e1ce39892c0fd886d6eef83a7cfd3b0d3d1da7053163d89eb74d2fae51e106c"
    sha256 cellar: :any_skip_relocation, catalina:      "8d4133786be94cbfe6a2b036c17751461c5d97fc4991dcdc0055dd3d42deeda6"
    sha256 cellar: :any_skip_relocation, mojave:        "6e86c4eb3020be61d23a3f68d35f50d35fb95e38b30d2389fde6d0371bbab5a6"
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
