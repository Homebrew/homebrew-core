class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "a3fe16d9e76872a1dc00c5ba7897806f0e8581a4f4ebb9cc8c4410ae2438d1a7"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4841aa81f69b6ea50733d63e23c7528536343221248c81cd98945d3bf4883b20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0528cf65555a5f86e2f3a9db038dc40eb019d147df4aee9b6a53e873c05db0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7717c20f5063a9e25a9b4c63a1aaa099623f16403803d24d86d9b3cd77822ca3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb9bcd54edc2c2a31f817c71a5ce5b5b2bccc818b8cd2ba1f71aedbc35465588"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b94a26a75cf78a3fe90e5fe425f0f69d82894785c65257b14656e6ab74cc39"
    sha256 cellar: :any_skip_relocation, ventura:       "9f842fa99341dcbe43ec4cfdce8c31f0be8545ae73cff012919728545d1e8a02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e9136f95e0097a22555e606e1b6c751012f740482b85c4c5677b3ad3b9b02fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55839055bb0e1849b304b2f4c7e1395b5f6d0c00abb16b7167f7b2b2771738c"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    # Generate and install shell completions
    system "cargo", "run", "--package", "xtask", "--no-default-features", "gencomp"
    bash_completion.install "target/completions/phylum.bash" => "phylum"
    zsh_completion.install "target/completions/_phylum"
    fish_completion.install "target/completions/phylum.fish"
  end

  def caveats
    <<~EOS
      No official extensions have been preinstalled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum --version")

    assert_match <<~EOS, shell_output("#{bin}/phylum status")
      Project: null
      Group: null
      Project Root: null
      Dependency Files: null
    EOS
  end
end
