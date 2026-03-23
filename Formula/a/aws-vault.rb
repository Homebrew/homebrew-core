class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.12.tar.gz"
  sha256 "1b6dc11d4f1d0a624bdf10b6f4fb3377d2d95fb78ea540dee2a7c2589a2055f6"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f20389dba23f0cd2494f5f002572009667201fb02602de4b1ef27bd8240e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f0a8b094639584ab94bb38c215bef78b1c689cd08ec908d241b3ee0f6a688a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45aef752527952a623c2c80732f93b491a995b91f9d4782a12f10320330020a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "84efc9273c134d2cb3b60aafc23028ef40afefeb15c2630d43129f9428f9887f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7dfe1966b12d8291278dd1be8a848b7ecf80a868b41180cf7c1b4ed3b4a31e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1369a0ab05e3985ddabf45e930bcfab3a94aefc62fe63dc50b8fdecf45dfb2"
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
