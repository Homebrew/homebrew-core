class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.25.2.tar.gz"
  sha256 "fd3eadf2905bfa6656d0afc0680db4b9f88ad4324ca792299943c6e49f114665"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a5509fb24df05cfde4f37f5ee06070a0d6ed9db8e041473bfa100c8b44b9690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "685da907a3bd60a3e29ba8125b009772fb2f174261d84adfbcc97e49dc17b751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a0ad64cbadebc545ff5498f4b529fa006ecbccc102ccedbfc0640b424b712c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a77b8f3c885793216f870627744c755de4b597032d197db401073a6b63a42deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "786b9bcb38eb64fb6704c01bb80c8d87c34f087da7a8213944bbab86120635cb"
    sha256 cellar: :any_skip_relocation, ventura:       "85d104db2d2ebff19895808a6257f19eeb852db300790d6a7a7dbc558557943d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ed7fbcbe9c4cbfeb3aa233e95714e4117a490aa3c13a1cca6ec4e1b9f7b4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f9ca33c1482c5be2651712d5ec0bc679775e88339d4a7afc0e5b85a7271592"
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
