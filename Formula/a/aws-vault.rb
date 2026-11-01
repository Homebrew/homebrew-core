class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.17.5.tar.gz"
  sha256 "97bc0cdec46950120efb2cef6bf641565c36f81d1aa322f8070566a3d74aef9e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b159d184bb9543c5ae3c623a530b4c7cca80a83716667fe41eebcc57cca512b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1a5c28c5b538157588ed9ca02036901209d02bebc54feebbe3ebd008f0a41a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ce310cd307f9296d0aeb219bb04542aa7a5c6c695947f1a7bd3990887dd56db"
    sha256 cellar: :any,                 arm64_linux:       "c755bf614b320cfe090dce64b77a62bd4b36e79dad90c9675c0b45c04340fd68"
    sha256 cellar: :any,                 x86_64_linux:      "2796b4f39a830318196fb019ed512dc870f91c9cfc15362d46efb814d98095f0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}-#{tap.user}")

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
