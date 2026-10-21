class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.16.0.tar.gz"
  sha256 "080f6f6e6d78c2b932378b89ac60a0dfd3319c9e040e7e39c831988361a10330"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d71607178e7cdfdb2de2eced468f52b8314cbf68bab6ab544ae406a6870bca17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a593ebe3435fe8ea3b863c701e1ac72275f9f508c587bceb83a212a350c72c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98bc7151b44a4112b2bb72838274513ef69c86497171eac9e74808be5e83be6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c5bb8cbe7bfb6defe84300035d16b8f75a351cbffeeb1868fb7c3e7958e2282a"
    sha256 cellar: :any,                 x86_64_linux:      "d01e31823b7a0167179741edd2ede02ea92bb3c3692950eb0fa46ad62c609fbf"
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
