class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.6.0.tar.gz"
  sha256 "c8038cc98bb8820d9bdd40a028e4788a91f8934220e8edf2134633571601cc80"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "54e8b06cb3b500c1e36a083f98f96b75da6ed3e098601686ea0b4592a842f6a4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4ca183f7e3d00a12786b71e2961c2d1fa7bbff42e2abd76fd4cf29fc234f959"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb6b69b256e9e3eaff3ffe639e1a807d118a3e456b8afad747636b17f6a6b565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59128887d952b4473baa904912129940585733f7ccab34a964d1b0d744ef1dab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a11b12521d70f9efdcdfb488de0714ef8f55dc8b87b65aa88e9661ee66495e95"
    sha256 cellar: :any,                 x86_64_linux:      "1534925eeb6d326dace2f83e0c65b66c5cca3e7f2cfe9d558de2ba59e0092448"
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
