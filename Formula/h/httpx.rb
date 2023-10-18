class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "f6b7d925337da55a6bf9e15144762887b0f2d6be8590381c90d911f8a91abea6"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f5e25f21fdaa78a31cc0344020f87fde8bc554c34c5f541a5a17caab54150e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d495cfac46706d4c30287c88013d533e6013c131620be8db832402d2696cf872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9a56d7ac53ec3ea98be90176bcc379526b4192394d5722fd9fedb4e96bd4993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c382d82937b6ae4caa0fec3d20eb477de61411557429b8e161929ba1d168842f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b10476f094e05cf031122fa524d6992eecd7bf4ab0210f9c99555055014cb24"
    sha256 cellar: :any_skip_relocation, ventura:        "35a0a5e66907cb538ffefc1532257de5788cbecb330120244f617a8018547832"
    sha256 cellar: :any_skip_relocation, monterey:       "9f82ee1c0fef77bbe4cedaa6c0e3b4b102b8ea04f4bd74058901848793bffc1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d27b6fcf9d0b437446163f725a7aaac9d9db27b0b0daff8bcfd104c3e997fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e1c215aa6f1be3db4c5968b9ea2083591e386de12210806cdacaacc446fa977"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
