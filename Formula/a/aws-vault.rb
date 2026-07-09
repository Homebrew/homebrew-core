class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.5.tar.gz"
  sha256 "64d3721aef8675f93103d7d26971d509245dcf4fe212deb003dc0e096e57b008"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcdd369c7d9a00619764fde2d0a317653446b311aea75096fc33c4e01a3615f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a5aaf288fd0e0325bbaa05b6e75f41a2db85ec4dd731fcc75ed3465994c4fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac280709ed5b218239f8d7d8a468136b3cacaf46b4edc0377fa8976899f1609"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3628a1de51c8fe96a92fd7d6fcf8344fdfba44dffbe7f0eb0bce50cca03113"
    sha256 cellar: :any,                 arm64_linux:   "d832caab6a70d4478feb76f990212eead92f8cf7b9d1dcfbdd74f68fa0a33177"
    sha256 cellar: :any,                 x86_64_linux:  "a727557686876a43056dd79c346ba6ca738e9033efc6c165ed4dd6de9a79b433"
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
