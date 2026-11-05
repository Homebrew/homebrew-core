class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.17.7.tar.gz"
  sha256 "234f5ea2e88c0a1caf7493c0d958f406d15ee9b9a77aa6c08cdb63d9ed723b4e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b0be54f140096041ed275c8334bae018031798911450372e65a9634aa8c0a43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03c7a0f041396d061f53ab2a2ee5ad1ef1ccccf8fad5fa527a4e2dcfe3e3b3ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39e25d2994ff4bf6170810dcce7b801bae245f67612aff9cf088c084665e709f"
    sha256 cellar: :any,                 arm64_linux:       "96bc545d999f564c33dc159e5463be0f950a06226558fb8f9606cdd3afb5c6a3"
    sha256 cellar: :any,                 x86_64_linux:      "ff0359ad351520a6e5310b0740f40758d8b042335946ba6d8d3c116c1642f90a"
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
