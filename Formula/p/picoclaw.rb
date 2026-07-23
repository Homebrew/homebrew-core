class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "df66f2f9a6fecf6f1396311b4a7881afc34d5f4209e2bebd6d91fb2b142d78d0"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aa92ded18c2e78270f5bf67b7cc61f3fdf75300354804163d0dc34f735a5848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa92ded18c2e78270f5bf67b7cc61f3fdf75300354804163d0dc34f735a5848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa92ded18c2e78270f5bf67b7cc61f3fdf75300354804163d0dc34f735a5848"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3f6afe484067720f13b13fff6c60c98d8fd6fd174e3f2b39969c1d809b3eb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7106accc8775ed6195f0506d7e6f1671fbf1589a57e02c9d0b932a994027bf88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1d3d94b2ee196f16c73566f4686a2eac7650e46ca5f716e14d8cf3cda2273a"
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
