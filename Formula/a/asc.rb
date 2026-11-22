class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.1.0.tar.gz"
  sha256 "153c34dbb99f850da0a13525cb1c32cd1e8604020acc4f5aab8560bc13ded27e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "bcc64ac52d10323a26acb35e4fe4f714835f23efea2bac23a6e637f858aca460"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bd688a7fede46db5dd66b01fa5c43e313b97f50205889ecc7f87beb45020dce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fc757a1199942b0b015c7377f188d1819900351c5dfaaabd389354d8cf179ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b18b9056f4144d71e1e99ff6eb0a8213e252239bb797a7aa4191ceae796f897"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "261bec4b29b9312e45a1bb5bd8584aefbf1622660d09fa9540482fe305e9b50b"
    sha256 cellar: :any,                 x86_64_linux:      "34713b6dce980e321bf55017d93be2ddf348e07bb9827bac272c0902b4d295de"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
