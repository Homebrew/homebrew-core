class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.4.0.tar.gz"
  sha256 "65c29c82cdbe8ef71264b47bb23f813d0a03f7bf327797846757c56a5b5f6577"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "c443a28013d5de04886801eb71b3af2cf5711376842f9c37c1dd174d05f32356"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a899e33ac92c4e31fd02d9555a89f6c649db6dd88f7b360dfabbb4e345b6079f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc028c55e388d6051230f977d7d33c9fb61a058d95a41925cb7b691b0cf34c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdcd2c390a5381d45e20140eb4e883e1853d0538ea68a807388ef3843270decf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "429200bb8f086493d2d35bd8976212d71fe1f274e0a3e19f661bfb36ba507619"
    sha256 cellar: :any,                 x86_64_linux:      "e7a2bfe8b8a4dffceb54e98dfd652bea3f5bf89cb3c6854c82fee794b228e938"
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
