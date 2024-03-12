class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "0dd51885ac2f7746e548b2d5527948c40e276803cbe3c610579c0fab8cf2058a"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37ffee8e9004091c2c361297fa956f8f6fc4cc672f87608fa7ff522a6e9ff8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc9b30f63f4e017f01b1f6c84c2ade49404d1508533813a569a072b9a6c06ba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7f47a5f33cd48d5cd06e62e27801994336f9d2797396bf239fb8c1748f246f"
    sha256 cellar: :any_skip_relocation, sonoma:         "31055c3d64ea77bcecb0805a6e9e86304d4c4338fe27259285336e710c7ca6ab"
    sha256 cellar: :any_skip_relocation, ventura:        "9133db6cdfd2b6354c416f17eb23f1c06e9f59429285da837904c5a8a9b4eed7"
    sha256 cellar: :any_skip_relocation, monterey:       "f3ff4981d185e7facbfb9061a5ebe818ba5ca78d18b36d8649b218e1625f7009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74fc04239a7b6961d77184dcb33ac4b6bfbd48e44faa7e76dea5b5d7d5eca4d2"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

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
