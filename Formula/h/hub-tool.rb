class HubTool < Formula
  desc "Docker Hub experimental CLI tool"
  homepage "https://github.com/docker/hub-tool"
  url "https://github.com/docker/hub-tool/archive/refs/tags/v04.6.tar.gz"
  sha256 "e033e027c4b6dc360abf530a00b3ac0caec5ab17788c015336eb59a5e854e7d1"
  license "Apache-2.0"
  head "https://github.com/docker/hub-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720b52ab08c879511e26cd49a0427fa32f6a227165a15c2cf06364f046a4ab53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a77e71f702e249983b474cfc5a48f8a74a4bb412bff7160f04a77b811fc6c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a77e71f702e249983b474cfc5a48f8a74a4bb412bff7160f04a77b811fc6c05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a77e71f702e249983b474cfc5a48f8a74a4bb412bff7160f04a77b811fc6c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ee0caebbd8e7a36566a14a720ee77d29cfb7f7efb7e85d25df4586ddc1d914"
    sha256 cellar: :any_skip_relocation, ventura:       "e3ee0caebbd8e7a36566a14a720ee77d29cfb7f7efb7e85d25df4586ddc1d914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4401fc85c1e8100d4488d87784827d766e94cb725f048b47c88aedc0b58740e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975161f22332ee0ed88c51528cea62b39144d231fff94f460c4c1650ccb23228"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/hub-tool/internal.Version=#{version}
      -X github.com/docker/hub-tool/internal.GitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hub-tool version")
    output = shell_output("#{bin}/hub-tool token 2>&1", 1)
    assert_match "You need to be logged in to Docker Hub to use this tool", output
  end
end
