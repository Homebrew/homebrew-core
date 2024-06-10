class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "117ef6af0bd17a623d1545a00c0e9a404fcb3cab34b32888dfca0302268a4d15"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a3df1fd3b64dd8516886d9a9792a3b8b491e788661287690deed3f72ccbf963"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ff61c6cf3a37c2b7d50ce4163c707a124696249409cc7c4d9379bb0428e4767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87f3fcee64b8fa27b9211c057a61a93c7ee77ea87b9b93f1dec1ca5bdf17c94"
    sha256 cellar: :any_skip_relocation, sonoma:         "3208b9159fb664361373068fade3720ed59e213975383c1807fb22dc0dbc6694"
    sha256 cellar: :any_skip_relocation, ventura:        "69abeccdb4a9995de288f25bb8ef820d3ad4dbf9783a1459d90daf1e38a55c95"
    sha256 cellar: :any_skip_relocation, monterey:       "463bce7193d20e84a073663da514e09c016139995bdfd5413073327a12318a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e1974d4d459978ccb03d9a71c2d873558b05c7a2331adab3623758d3e91761"
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
