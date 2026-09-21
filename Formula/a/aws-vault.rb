class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.14.0.tar.gz"
  sha256 "17c13c6d3335510cbd1d0603df67764b63c467eb46781307d12d2dc84bf5e82e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddbb736da2c23df495c23d2bacd546f19b1e12da7618555797868a6ab005659a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8098046aa91fc0af8aa88b9dc07a8fc2fa1ab3f95d0e11d933bfe582be48191f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d1fe307a457eb32408568dbeed4b5556515abd61973645d4673e1699ebbb353"
    sha256 cellar: :any,                 arm64_linux:       "5f36318bf91e484a9c78d23c64a97dd85eec1421f945bf15b5f645199b26d85b"
    sha256 cellar: :any,                 x86_64_linux:      "5c661f30fe1276714bb01a2eebe4e9f96aa280aa7e6720d20f8f7cf7bbbbe618"
  end

  depends_on "go" => :build

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
