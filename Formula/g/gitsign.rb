class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "646a86c2ff1786c2879b323304a1559c0b7f78913b9c825faa8612f6855be6b3"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7847cd2802db55c980085b250da07e1271e4520da78a6544782564b769fdb53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7847cd2802db55c980085b250da07e1271e4520da78a6544782564b769fdb53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7847cd2802db55c980085b250da07e1271e4520da78a6544782564b769fdb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "62c704fa9d17bb814ddd3f1fd0ff6d855ddc3accd9c492a6f16bed211cb4446c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad07cfcbccfbb7aa38325c47faa37face71853be5a4b74bdf3512ee21132ba4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eccd294e00f5cef0ec73454a2e80ac13fc93ca287b20876fc473b0a874d111c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
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
