class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  stable do
    url "https://github.com/coder/coder/archive/refs/tags/v2.28.6.tar.gz"
    sha256 "294e8f3d0b8bfa2ada25ddbc7cb5cdb479d0293459bbc2b60b28fb76795108b8"

    # fix invalid pseudo-version issue for `coder/boundary`, upstream pr ref, https://github.com/coder/coder/pull/21290
    patch do
      url "https://github.com/coder/coder/commit/b690c3e90b42b1c6c81899a603789d309e64aafb.patch?full_index=1"
      sha256 "09734d19299872eac2fa10bb45eca619a66455817e9ebf45f09a484f3218b864"
    end
  end

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "562ec6299846281fcbda88715b88f4b7bc2a76383def442e11ee9a0918bf1dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3722049ee34a915e4acd530ae9e0bec4cab95e466cb6f03f974f75fa754f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b391b8e2eae7670173322f64095f96961f47df434404de1802d97be641df3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb9fce97769e9cc1b0fe1e8a5aece73ea0726d8d98f740af28873926a5c0437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb68e392d994450afc502fe5883b7e70bb7c50f20d6c2401698da80ea159964d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113ace2a68fd34b94fa0e830209c58ecd0a9d3e5ff7b8658882ac67a4220f240"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
