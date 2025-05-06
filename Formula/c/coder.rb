class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.20.3.tar.gz"
  sha256 "d1175b481da69996b8c09d37f9e258b4e4d938a750ed7fbc004717fa4b87309f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028446300178cf51ebbedad81d2f5f755e8fe1174996cc8a2885fae3ed5bbe52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293394be5f2d5bf8ba83cae2d39034295f3156223b7871cc4a0ec2d28a0f380c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c576e02f808de58f63a7a6c597c4c8544f921b00dc68f9efc255e62d556ede48"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8d12798b0931b975fa0d3e03357855448099a0e9bac784a1437da434916862a"
    sha256 cellar: :any_skip_relocation, ventura:       "96dfb98494c764e615df9c36049ca02b3fa6a7cc745f8bd42f069f4a4a9b57e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c3d48320a5e44df8e5a458f21b643239dde3ff42576a6b60462a65b74f91bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09c909551d9b57980db98bcf492174c83103a63ad6f1f513746bebf950bffa27"
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
