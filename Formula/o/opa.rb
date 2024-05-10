class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "54be7256d4cc70e220eb796b56cb5e63d129f9fcbf2bfdd84d251c24d41bd848"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "799481ab9fc2d5fe2841094bb0ad5f46a2e7bd4c23ac3b4f59bddfeb7055da23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3188b242469a473dc612e0a445e604f505abf26569727b65de2df91ba6d38a92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c75ae4d424df06c1ce129bda428e52e5f55da8672be4ec53415ec4802a3d60f"
    sha256 cellar: :any_skip_relocation, sonoma:         "75de4bda9872ee721be965731c943ec5a25fc5d9eb2a11b6a755457abaa598bc"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6d294c6a89f1f5ce26524071162959b75868e1ed956cbd1ef12285c8321247"
    sha256 cellar: :any_skip_relocation, monterey:       "0c663fcf99fcda5c822c42592de6c2c7d31cc304996a29b7433c0315bf4a2f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "187906d3af797f6e242563b870e7829f8f4bb86e4b943b3354c9f40468ee6bf3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
