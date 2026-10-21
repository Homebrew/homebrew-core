class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.17.1.tar.gz"
  sha256 "2f6e0b7c4fa14eee7975d2a38cf61e5865ebab783ba8a9408c4bb095c6b310f9"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c356829ea1c8181a27f9d1bfecc23fc6941fd7e137e28965ea33e2a0762d75fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d44dd84fd9e3323e87ff22438e3f2642aad817016afff49d45114fb0df4bb55a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "382bf9827e38e5cfb85978dc575ad7a3c273eb31b5500260aeb6710acb84426c"
    sha256 cellar: :any,                 arm64_linux:       "aa24ace2838b5575d520080ccc99ae583d5eb851ed592a825999a916b6e2db95"
    sha256 cellar: :any,                 x86_64_linux:      "d0b08ee0b8aa1a99ef4f28383b94f550b3775525233e60be3e7fd89f01d4ba00"
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
