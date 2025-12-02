class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.13.tar.gz"
  sha256 "41b71d9a0a7493515f7542a363587bc1e0c096b10a8133058d7b2bea41c80c06"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2449f22d52ce01827c1c1b14103dfb5916897b3967a6491475b044ec64aeefeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfdf45cc565d05cca523e0bbb12fcba6453b7a3cf386069ff96795559fa32cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "658e2dcf24080b2f074b0a6fda146ba7b97f5988912b2d30dd51f42ebb90e75e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a05f3362a2dcb9822a468e13e8c000958bf4f1a1275f7f7f67474835af5e742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8785355cf863bfb618f8614262c7cfc5cd3586f61f62cf3a40ae5649a376bc3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a483af8ffaa1a610c350514bb10c1223c1774fb1eccc85629db8d4fb7c67cd7"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

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
