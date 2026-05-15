class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "2a550c9b609c5eb0e1c2640e8114ac05b94c671803f77e08a9dcdbd66372e2c4"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b9bcbe1de4005a065c87110f3ae0993a88e67efec96b0c9a863f0c35ec1460f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9bcbe1de4005a065c87110f3ae0993a88e67efec96b0c9a863f0c35ec1460f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b9bcbe1de4005a065c87110f3ae0993a88e67efec96b0c9a863f0c35ec1460f"
    sha256 cellar: :any_skip_relocation, sonoma:        "af6d4ee7cd246a3602867d42d5ac9a22130d9beffaa0596d0b89e3099befc94e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd8536410f6863541a6f88e06f0fe0592556cd1a381974bd1ec42c8ee97ed09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59188b1a68d4c954d0557a2e714abfe93ded706ff378ed6c3aab6cb73b212591"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
