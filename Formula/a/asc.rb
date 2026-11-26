class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.6.0.tar.gz"
  sha256 "c8038cc98bb8820d9bdd40a028e4788a91f8934220e8edf2134633571601cc80"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "375879e0ac693ea8994dcbe39621dfbe6a516754ff21aab00b61547c1542bb4f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad92673f9fd27b8a0810e772f8e1fedf5f42a18ae7da8b92ba09b74b26d6ea1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7134752892ae0a22966fee8be2d5888daf538be23fc12a63efdeac75ad95a52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cda318b78b816433067918a3d7bacd1be9fa13dec0f7ad7fdb5867f878190814"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "177cfc80d4d6925cb30dd328667a346770ded0cb529037e440ab01f9635a9a73"
    sha256 cellar: :any,                 x86_64_linux:      "e3fa59156aa0cf26b7823b1f72e28b8a8686e686a47f4403b51c656462e2dbf7"
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
