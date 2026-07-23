class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.34.6.tar.gz"
  sha256 "2b2398b18ecc8907c42e8970fced5a4bcec67dc1109d234678801216e2bb7454"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ce18bab81d6c3f2807137a8b0f9c6ac7aaaf5472b366411f62ff076c874423d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b926f0783d4c247a7aab6ad98e154c3220f19214c43da7074d04beaf90e9aa93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "421a151d9655e7365474922d4f2a4075f2dadf36d11288ed4df601fc29ff135f"
    sha256 cellar: :any_skip_relocation, sonoma:        "71884113609a5c76eb3d0e9842c37646e3cbe50cee9af1b4658df8ddc6344577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8aa282d15890ad86d629fa6f9ed1df9935615b7344c560949d02120cb79950a"
    sha256 cellar: :any,                 x86_64_linux:  "f1177354c11430816d5260a675fea9cf7a61e7a35983d844087622436061170c"
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
