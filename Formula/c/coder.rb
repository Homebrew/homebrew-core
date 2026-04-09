class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.31.8.tar.gz"
  sha256 "cc4477b32617771aa6adbdeca8dffd8dee18f16a7723c77dd5477a370f11dea7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dceb83d2607406e0a590e824edbfb72865aedefe4a448a54489cbd185ba8d243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeb455955f319a16c585efd3f7247e94469d6a9d01cfc273a8a6d0522baab0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a96756e094d296b24b5af8021432d2ad41695c4e653370ec8a6413a6929a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "004afd8a4afb0e2ef0a9614426cd14e44eb52c49c5a1de1fa60e8b9898407272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bcee2fb9993435fedff062560319a7368f04553fdc40a2ac20915ef9c270872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009a56f5d41f3d17e39b727b4de7cc12f26d04ff0cd6d1af0c7ca87d87bc83e5"
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
