class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.3.1.tar.gz"
  sha256 "cdd33a9d858659786b26f0b6e173fd179da4f221c1ab743b32236a1b16a04ef0"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "7c82d7bf15cec908ccf559b46d46483d0b8524dc35454566c35dd462d8d681aa"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0fc8cd678dd105c08b553754a65599785965baaa2fc514631b36d5421c9ba82e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4b459b09abfae33231d62cb60fdaf8751069d76780c5c00fec1cb422fc8f81e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8cedc635c9ee7a52c8ecb518ed493abf3802addd1fd21915c96892af3387c52"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2fee52e63c02dd9b4187acb203e1951eed4d1a9551996710f349d8d0369ee914"
    sha256 cellar: :any,                 x86_64_linux:      "c9ba9506580cd121b95da819a9d79568a8036a710ae029ecb8f632703b19bb4b"
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
