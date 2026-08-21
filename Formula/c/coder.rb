class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.35.4.tar.gz"
  sha256 "c4e10d53c51138a517cd35a338f15a7e9ef220d4ed4faf5a7e4063f4802d0eaf"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38a4478ede7f2ec05d3ac9fae735ea3fc6cf36da619cb215e18772b1793d029b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f10150fd33e3d31fafe14dee00aa2a661b81ee3153047bea7c21e956b7e2d30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e5facf163ebe0a4bdd09ef1a01e2e8fea461ac888c98f0bc23593dc7309322"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8db54826d3f6dc49b20313000b4f3a7415e63d12a2d0415c06346895bab5bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c2800b0ac727da1c880b80b35f1323b8c85be1d0363fcb1bf5fc2d669db8daa"
    sha256 cellar: :any,                 x86_64_linux:  "8faa27118ec43d98bc0ee525b9a4dea7d6a2dfbfabfd3930a468462543b99767"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
