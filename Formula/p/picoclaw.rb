class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "a3bf04370c86a6983ce9376edcaf1c5187bc764fc54e1a2499fef23891f1c257"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4693ab6bab276fc540e0966cc626d443c965a842b48f62947415a24d8676f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4693ab6bab276fc540e0966cc626d443c965a842b48f62947415a24d8676f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4693ab6bab276fc540e0966cc626d443c965a842b48f62947415a24d8676f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9833625a4bc858bbc85249405e348fb589b4b016efbcad8aae25fdebc885b716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d94d24b3a945dc6b7964a5852bf2470ef905128ab6638e401974754759a4c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549857b5cf3ccfab832250e494e69e7b7a0ae6ad5a3d769a27e34de889633e77"
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
