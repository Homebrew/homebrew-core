class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.3.tar.gz"
  sha256 "4ac9d32ff5b68e7ef13b008d8789c31f4b3e80c5a736d03c5739880c859d804f"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48cd98315ab404538808bafb0e2dcf1baf26d93c022d7c8ce1b5b1af86514a3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc425ea9e4f814bcbb8d762ad1b20c58d9ced18e9d7e79548961743dd5b8d41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57be5007a641416043e7fd0f081948db2699ab65e9384d7cf3ed6e1f604d6526"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4aa9f011c1a3656902867e6e2b99177563e51f1b41d25d9991a488b94cb930"
    sha256 cellar: :any,                 arm64_linux:   "566e81fabf4fbbe06095ef3c17b7b7e49ebb547bcc0706772fa48807b73ffd59"
    sha256 cellar: :any,                 x86_64_linux:  "067967d1818dbcfd55b5526b09166beb0cd7185a5eb68b0033edc12247a85340"
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
