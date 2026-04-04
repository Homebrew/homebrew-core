class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.14.tar.gz"
  sha256 "71fed3416f0508e6217eff0e2ddb5a3a25588b0ba6dcc8bb859134eb85461695"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9053a4446ec9acba2d4bdfb9432531135b8c8c2ce5a8605126445f34159a19a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d74108d53029b4b9678f9b50a0a5c4890e338c060f9c88d7d984e40cc421002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6beb32d89c52955fb9d8d889e1fbdcb63e6dd3daf8837764efeebdfbbf047015"
    sha256 cellar: :any_skip_relocation, sonoma:        "81980960bfdaa0568103348e46b01543baa7794ad651a125db80174e57ef5615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c56d73631821c7175aae2346e36db7da13dca64d9106cceb154c6d551c6dfb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11733bac605e4f86372f0f23eaa683d8ed8fc5f5f813693e3e8776c50f85ef61"
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
