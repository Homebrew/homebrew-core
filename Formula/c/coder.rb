class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.25.3.tar.gz"
  sha256 "f042ed1fcf454f4915c6b1a60ba27a0225384c429aec5d1d4f5f8b6da00922b4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecc22d9bc06495255b235062a7e3c7b5da8d26a105c2657bc1e31a7dbb0008e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a1520717287c4a9313ef9fcf82eaaaed767b36eef8e8f834b1f27fd43b7e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10cee63c0dd5ac5803a58d73de452f72073a498bf2d5dc4f736329545b2cbb39"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf3749e03356d2762d03fa3519257e8b332fb9b63446e74f9d0d0437b463c4e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "718d2ac4d17a2d41160a8874073f5de2d8e574414e2b8d538812186513d67bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c88e482423745e58f00e96e442c97a553920cc8ec4dee9615066db539a75df4"
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
