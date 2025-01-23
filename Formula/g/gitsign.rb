class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "80a36439bbb01f4282792cd75257b52689e7eee9b0c6b9a635dfbff2958c9207"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21277de84b9ee9e32baf5f5317c924ba9c93184589e841adf750780b6372c9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21277de84b9ee9e32baf5f5317c924ba9c93184589e841adf750780b6372c9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21277de84b9ee9e32baf5f5317c924ba9c93184589e841adf750780b6372c9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "77fc1aade030292552a5d27d185236a0575960f7cd13aa6dde0a0417ec2a90d3"
    sha256 cellar: :any_skip_relocation, ventura:       "e40818033b724c131c0eb4b5d49a58659144996a0c6948bdffe81e4dc454db29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b717b8857195599c64f22e1d82a866ef9fc851730ed1a65a6b4fe8343beb71"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
