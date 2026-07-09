class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.88.tar.gz"
  sha256 "db79ca726343f3b12568346610881f03fa22f253a57326ca7c196e334244ab89"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce1714b819e33da9f821cb84f9a620feba9cebe0b41097985004cb724cc7c9a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08666bc42cc6fca3c7e9cce020c0d7829fc9fbdf59728123a362d8c20caaa72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2110406f1726506f6f14905f77e38d5a4aead3cdf3187ddc2f9dd82ba5c7150"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38ed2217571e1fd736a402076ef42e2a9ea6913cb13aa3b7014f4f201db1943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac80b48fc02cfce4eb2f4995c7fd94572ea73b1191e5ee9dbb07b7f07b68aa6"
    sha256 cellar: :any,                 x86_64_linux:  "00455f830faa366c35492dd93d3fe57ef8cbb5880f2070738e9617098e14bbec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/obot-platform/nanobot/pkg/version.Tag=v#{version}
      -X github.com/obot-platform/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
