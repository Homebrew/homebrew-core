class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "80a36439bbb01f4282792cd75257b52689e7eee9b0c6b9a635dfbff2958c9207"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab494ff5ee1a8285de439b716caa7583921d7306f31ea728363897b8d64027f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab494ff5ee1a8285de439b716caa7583921d7306f31ea728363897b8d64027f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab494ff5ee1a8285de439b716caa7583921d7306f31ea728363897b8d64027f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "556b44958ae647b69db84b6fcc0e1585b9e208efd60cd04a72e6048f3114c9e5"
    sha256 cellar: :any_skip_relocation, ventura:       "ff7316b17434f076950a74a5f55fbbec46b31b6c7dd0081a596bff5be33729d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9b208e65656564acdc4651a3a3f78dc5d52accee7bbc2efd92c7fc99c86579"
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
