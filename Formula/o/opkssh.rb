class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "b7c326b24d6fe97056d459f2d5ef7eafb25890b70279537746a368467fe2dc3b"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "990e3b109f723e7f579bb7687cfefa420ea26793adb1ce1d3dc5e2e67f66b29d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990e3b109f723e7f579bb7687cfefa420ea26793adb1ce1d3dc5e2e67f66b29d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990e3b109f723e7f579bb7687cfefa420ea26793adb1ce1d3dc5e2e67f66b29d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d342daee2547aeee8880f731222112df05d2226c7d7d2ae4cd8d6d8c0bc6a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "472fde1f8d76553da0b93c54462adf1cb3d7b61c2d401252e6665ca4923059f0"
    sha256 cellar: :any,                 x86_64_linux:  "2dd6b9c3ecceca5ee15f5c41fe25a8d17ff3bc9314bc51b9ea6dea88798c7411"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
