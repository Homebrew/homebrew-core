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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c969ed7b387d8c21bf128c9a573e73d84a7e64303f36af0acbf14625b34ee154"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5159492c765b5cdb4745d9711be9f4ed808ce10d426a80021c3f913bb7d3abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fa82cbfa28f00a6e8b8ab2308aa12fbace37515f48a42c62de42abab9d851f5"
    sha256 cellar: :any,                 arm64_linux:       "24d816d3d116978a1b07cbd672b92c6dff640caa8b7805fb4894800a5140c0f5"
    sha256 cellar: :any,                 x86_64_linux:      "8cb4a793cc81543f4871dc063e716b88d59e17615db5a61ab7446973b3d3b87f"
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
