class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.5.tar.gz"
  sha256 "16207d853150b0ee13ed9885a4ab2e7be4a74cfe99ac7c2b7ce84c4e75de6d84"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02049d6a7f38354dacae525d29010024438666fdc9e5b93612efefdd416ce300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e7b1263b15e5d83a1c7474381f1a2f5433bfb2ef9350ce7fcd085bfe7625b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a578383c5ec46aa0627fcd8540b10461c1732b53a0d868221daf769894a45510"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73ffff3d381caa2fc876808b20b08fd2a8ab0bc2ff427f4b031ea18f22e141b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0e77649f4f630f9855f6e9a5950cddb9b97fb27c0c4f381023fec816c8f0dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca8c51cc1aa8a60d85d3c64defb97265c3aaa6a6ea9361d9b38d8ee17482f12"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version}-#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "."

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh" => "_aws-vault"
    bash_completion.install "contrib/completions/bash/aws-vault.bash" => "aws-vault"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: unable to select a 'profile', nor any AWS env vars found.",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
