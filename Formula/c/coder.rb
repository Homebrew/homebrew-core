class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "8614bd2c88796eca9978641db8437247e2c28c686113f98a0f1f402b021008a2"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16a830c1e04d299d11dc133b6d6612382072304e7c3d5a2b0ff4af0ad89a70a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ee9573a7af1467c1e73da7a627db5705a27faac23cecc37654e845e9147d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d80e1f10569147bebeacdd4e5f5aadcfc6d2890a608c646b220dab38f768063"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7725573d5222a7ca562d4c0959d1782b865c08950a7556b6fc48d2ad4f6c189"
    sha256 cellar: :any_skip_relocation, ventura:       "4bbfe3e21c847bcfb9ce10d5153f8b5639111dbac4cc02dc0636123c17b1198f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "101f04a20e7cf956f5bce143b198686424044ae2d6d800b4ae202fd9291d470e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
