class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.18.1.tar.gz"
  sha256 "013f6199a20dc807df99ee5b84e1d6b6dbd0ba78df88eefc08b86c01d30cdd16"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4fa9793635cb3c57727f457e5e0830f23ee35289c6a436a6efdcf03bc2359e22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e15737b92a354cc352ed0f96881639b3b977c464a923454e5e1c438a2fa8787a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7a03709e12654cec247d48ec09ac0efbdd395d0d355ccfb17168248a9cff26b"
    sha256 cellar: :any,                 arm64_linux:       "6984d30fb913e478b03e14ba73205e72f6a0ed4362c510c7f21b772276732dbd"
    sha256 cellar: :any,                 x86_64_linux:      "4961eb71ae998b20c95fe6ebc9a30789e3047c135b84d0360c76dc7fd656f9b0"
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
