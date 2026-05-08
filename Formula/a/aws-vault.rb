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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c47be4b34e045b54eac21dea387c41cbf09eeef829af8b3d85c90ba722a0cb8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5b944f8911d2d733187078077dc068951ae9d347753b49689d6c7fa5eee5b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b3e99bee52aaf00c91751c3de2736e9dc7b40f7e6aaafb8a0c7f85d009de48"
    sha256 cellar: :any_skip_relocation, sonoma:        "da96f5c1c97f4c0a1e3785a0d3e01026a61c53b6792f101dd46ad9de43cbc061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2b7af5fd61675be07baf21183dcc0df6148de1cb7d88488e4c8973161e23e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbcab1d3b137cf3e27c8c6e2a40914d8bd989801969e84705077c67822005890"
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
