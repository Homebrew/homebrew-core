class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.2",
      revision: "53e6a5be9a611323401a3d98d2dd380da4f672f9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad3dc5f0f14f3c7e783b9120ff422729bcf26cf68cfdee1ed6e1c6d19ae404e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33c813c05e5a0d4b7ba3d32b904732082898147b361fd0bad5b3722272a69501"
    sha256 cellar: :any_skip_relocation, monterey:       "941fe93968869fbf859be2c98f7af5278479bbb3962a28781f0c30bc6e7d2c21"
    sha256 cellar: :any_skip_relocation, big_sur:        "005c89786e97a64c396073aea46bfbb15132ae23e189d75d98cf22a75f9a61f9"
    sha256 cellar: :any_skip_relocation, catalina:       "bff2244b8b16aedd81d13b5614c9eeebe3f6f5597dc5fdd864a4b143c1bbe82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe633a732050f703b43cee6b142c6529e1a62266682585b563cc657262cca02"
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
