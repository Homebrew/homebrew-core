class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "646a86c2ff1786c2879b323304a1559c0b7f78913b9c825faa8612f6855be6b3"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c2a101565f82758b976bb9a9bc8ac9247e40f204189d35ef5ee70173c59c60c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb69be6710bca5b749df22b3e2667ccf6c956bb3bcbb3514233fc1c6b25d5ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb69be6710bca5b749df22b3e2667ccf6c956bb3bcbb3514233fc1c6b25d5ebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb69be6710bca5b749df22b3e2667ccf6c956bb3bcbb3514233fc1c6b25d5ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3eef280e52665777633f316053e44d2592a085352b96336fbe40e53aed80602"
    sha256 cellar: :any_skip_relocation, ventura:       "6167f0a2d13d9bf172de4677fe293375f0aa39190681f5b5c15f76f5429dec35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f81d8a7b65f63a7c9f8f1aa1c4809c15ab1530ea91703b5f0f8c774ecc02726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2ec9b3d99c682cf9e036d6eb7b596116df6b38e469264c0f3cb909e4bc37b1"
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
