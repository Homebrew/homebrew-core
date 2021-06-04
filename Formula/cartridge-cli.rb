class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.9.1",
      revision: "5770f5e62e71271c216e59e81934fda8b58e0039"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c71e2ad16ccad4fd763bf16764a0561544a75002578c489d07d05035a40fade4"
    sha256 cellar: :any_skip_relocation, big_sur:       "71cae5381ab4d0ab1a09d1d523cab9c39e48f786fbc65bdc1aed1fe641fd4eba"
    sha256 cellar: :any_skip_relocation, catalina:      "4e3f9ffa29ba823041fe460d116afeb9a37c7453bca4f658c9a88d0baff3fbf9"
    sha256 cellar: :any_skip_relocation, mojave:        "19eaa3369041b180f581a6b27d2816dde06eae5b214410e882fd9add29061a81"
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
