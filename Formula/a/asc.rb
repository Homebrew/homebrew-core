class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.5.3.tar.gz"
  sha256 "a026efd3331da78fc5b546051c3f8e0ec87a8828e72a58d1418c943abc205186"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76b79b13c7397ab0d4e8d9833f6c6ca9144b7760ae11ba99ccdcfb3fc59cc76f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7a0087d7d1931221246ea4110e433bd61a1f8606655bf649353f637c3e5c80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb3b6192472bca33bd478c0b2085956dc607590be70ca9f40e484040736aaeb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b576e3d6e9a9d051683739d7e64a6dca3a4c451c7074cc27494c171a664a7c11"
    sha256 cellar: :any,                 x86_64_linux:      "2b2415724bc91467f131879605c5defd729c283fc3d97ce253e676f0471d870f"
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
