class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.23.3.tar.gz"
  sha256 "424e7787cad50d3398f397182487f59362896d2c62d3ff179b6ec8b4e7c06fb1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab3f855d4a82ed62ed4146726fc4c1a9aa3aa6c1f07f80d82b0a6323c8a00e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e2492721df451723cc8c82dc033942ad5a44dd89e39ee82f2d7ca58eeea1be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6a8176a331cbae1005fc3ff61a7b50993fec7807dbbf476c5d68f7ba6a0cb96"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc49d730bbaaa42b2ea61a1a13730ac09b7028969be8dccd0ce353c332a8d0b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f18079dd6f27869b610a29ae266e1a225f5b61ea21f88b668c20ec21dd7c7507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3383b75fca978af7d022a96fa20cc70bee4c1c43a59685d7c2c2565005eaf899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3456e08318a6c4e953c5c827ddc150835007c811d445b05a65881e2b4ec6920e"
  end

  depends_on "go" => :build

  # purego build patch, upstream pr ref, https://github.com/coder/coder/pull/18021
  patch do
    url "https://github.com/coder/coder/commit/e3915cb199a05a21a6dd17b525068a6cb5949d65.patch?full_index=1"
    sha256 "ec0f27618f69d867ecc04c8eae648eca188e4db5b1d27e1d6bcc1bde64383cdf"
  end

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
