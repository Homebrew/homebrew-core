class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "1e75f68d12a70a6ba5c79c578d0ec52cca491aa2a3f553cead89c8e2ae054418"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41d0a8ce8869d74a4bc31810c4a29bb3eea231df8735517762f73c135d34631c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d0a8ce8869d74a4bc31810c4a29bb3eea231df8735517762f73c135d34631c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41d0a8ce8869d74a4bc31810c4a29bb3eea231df8735517762f73c135d34631c"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b3968ac4c0dd72d8443797df58516441e7b8f7f625bbf4c2166e67d2b4789f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3c043734a262b2b071cf64a742dec1ed5bf34e42a632f2111121ea5abde337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6997dd9e60973701d091928e4b39931e0851b22c14b4b15850bc47f38643eaa4"
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
