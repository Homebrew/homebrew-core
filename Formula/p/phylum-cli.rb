class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.6.0.tar.gz"
  sha256 "6bc740525c8a9dfa87f20e1abf89233fc5fc91e151b3d9734bb079b9f78f87da"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be0afa841965afac034aced46e3aaa01012e723898a388838a465ae2ca39c3b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8da71b4b309a1a1e50f3668d25d547a107ef18772c552de4fb257aca9bf5f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c42195d6dc7c7762f15a9a9a43304fa628a25a7101f011ac987757bff1ea88"
    sha256 cellar: :any_skip_relocation, sonoma:         "249f617356e3b681b9a46e1425cebfd87e5a9d043c929e7e265f8c201e22cb99"
    sha256 cellar: :any_skip_relocation, ventura:        "ad111a91e02ccfa8b4f809e8f8544d680bfa3b203df05790a5f7e26cff90e8e6"
    sha256 cellar: :any_skip_relocation, monterey:       "5ffb8110461f6d261d84c35f93962dc766d0d9701968eee43827fe2aa410c001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0215dbe4d8ea788e938b738dd2e133de1e4bc455184e726937fceee25a9cc1f8"
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

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end
