class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.27.6.tar.gz"
  sha256 "16fb9caf8a04740f4262d774e027f11c32c936f524c178184b6c1704f4ca1460"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a24e0571f999d230c0e55c7a280c116f8a2946f64bed97f2320774982c1c497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1003a0b02ebba9ca25bf2d9e18a3ff07e81eda4635135811701ab63ff6300c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637ef228df53f1edb94c0b52378fee3a9d537063f9eacc5f5c091a7f58b90018"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfeb0cb69ce3cbc05b576018f5506535ca2686ed93cdf42962aa8013b319501e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3a72ead49313e4abe3d323b95167f22b1af921d9461ed752d9a333f79915d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fa7944753e1c32182e5ba5b219af8c616ba177edea68a871cf6fc3f2935ae1"
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
