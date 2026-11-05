class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.17.6.tar.gz"
  sha256 "4dd2547101623bdb4c63c913731c721539119703042f37bc538f916e4acbb755"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8cd3381e333955f99e19598d3484f65b7cefbe6b1a3f0286326438073a4307f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "474f88e973d0b641b1359eb0c500a74951765a726471876ed6b5b2c97e011d4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd3cd0ad0f24c1117b009315bb9862172e214fef612e3b8be57666b8864d0e95"
    sha256 cellar: :any,                 arm64_linux:       "0949e7dafd33bac615a8acc3726784ae9827d28223bac221a0dd3ca4421a4f91"
    sha256 cellar: :any,                 x86_64_linux:      "b34d4a338208fe82fa1125e046a4c7ae0ad9d34a51536bbb7846c0c2335924ae"
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
