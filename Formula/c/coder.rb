class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.33.9.tar.gz"
  sha256 "a4ca9e6b4f0c74cd0e1df3ddb48572f578df892f8f336d4230216f9d47a7764c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08627790262cdacbde623a3da6c1b97d6017c53e2e955c946130c1ef90fb5133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b5a40bd7415867d13f6d50286c40adf3989068d1af8e02012ef549630cc75d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9906fd1cde1872bfae361317cb0e9b8b3c78613405f86404f4fc9866ae1bff47"
    sha256 cellar: :any_skip_relocation, sonoma:        "e368aee4256d03df825b4945d2522d4971f57196fa9401b88608ac58f03f5e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df1b4e831ad82e5d1130ad68726eb0f8b67fe4a8c25641afa72f9485895ca870"
    sha256 cellar: :any,                 x86_64_linux:  "8136904c1c74f470f6dfe4d5d1e57eb4dee1daa09079e1bdddbfa9daab4f9a66"
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
