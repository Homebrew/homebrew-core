class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.12",
      revision: "7f7efcfd4aaf7a2b4061f8424b6843a462794ed6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c347030987d8638b17325dedf3ecd8a8271de8f1333aa086f7cfb0777c0ff8ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bec51f07e6312f149f7d4dfadbbb9475de7dba2cae02d65f3ad4c5cc07b4305b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a7b997d1e63a70c5c0105897c6d0299d7df81b3b90d2a4b8c80966950a86bb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8933d2dccd2dfaeaa4e7082fe7df22bef8c8a8937187e7985ce5a6d367ad7d9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "874bc7b926c982d443adb209a19969ad5032f2e35d1a910244dec1811f998409"
    sha256 cellar: :any_skip_relocation, ventura:        "a64cba32bee84f91839d527ce7abc3ec6a2d615ba82958940095e4358aafc771"
    sha256 cellar: :any_skip_relocation, monterey:       "7f4458bfa8b116866c305eac02b5fac4fcbd2b210a903ad2026003fa1782119b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f45b6fa23e7590d4aa466946ce87f8b8fa9dec0fb3863f853d3131c8659c61"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    system "mage", "build"
    bin.install "cartridge"
    generate_completions_from_executable(bin/"cartridge", "gen", "completion",
                                         shells:                 [:bash, :zsh],
                                         shell_parameter_format: :none)
  end

  test do
    project_path = Pathname("test-project")
    rm_r(project_path) if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
