class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.18.0.tar.gz"
  sha256 "957408bf9337e42d20f2c98958c7dfb20272072653c88ccc6c2d39650a084ced"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29c7a5d2bfe7a04b4857a039c197e1c6034a73c99f69f86e5c7b978f6668334b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a22c9303c3ea5c969e2e3652e77a7ae0be4bbf47cf9c5953026edeabe9f4970a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11c206ae0bae454bbddaad9916cb83412fecaafe2924743bd1e51af9694496b1"
    sha256 cellar: :any,                 arm64_linux:       "9a6ade88d83ed5943b09ccf1afafc8b8a48ccf46671af1eb8ec20b84000dcbcf"
    sha256 cellar: :any,                 x86_64_linux:      "a5090c0b8f19facadfe257fc41fd4cf4f9dc441aba28e96b14783e0fc343febe"
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
