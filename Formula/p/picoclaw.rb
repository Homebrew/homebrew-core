class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "656241e6b4756c2f6c297473d759130874740a2962b1a65a54de717a19102166"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c2f00b9ab0029c87fbf1acb27bca6284f392436034a674e5220e6f513f70a52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2f00b9ab0029c87fbf1acb27bca6284f392436034a674e5220e6f513f70a52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c2f00b9ab0029c87fbf1acb27bca6284f392436034a674e5220e6f513f70a52"
    sha256 cellar: :any_skip_relocation, sonoma:        "b369e81ded2945fb4d9d18dbf75413e38de09e1e803337582579feef62771f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "872075a5ce586d14be9b2b1fee7f82c71ffa695661c5a0b6d5e81a4ecca36767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a15a0709a6554be8191f2ebb53c39103bfe2f5c8ac87ddc628b7f2e61134f1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    tags = "goolm,stdjson"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENT.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end
