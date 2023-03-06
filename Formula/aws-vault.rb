class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v7.0.0.tar.gz"
  sha256 "99e083ecca719c8870a38fbc8f4bd1f23985160f187bf5fb02f91a5f149c0323"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76c232b7c8508273d7d02a2d68a3940298553dae91c82bd7eb477c470cc7da6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b7ebc7a75cd1f0277aaba5b57916e52dd4c4a221c0b801e26fadb82d8c6d5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1da9448246143cf6a195a0c01fe5c27ab9c45472e5dcb4beca1f8d92a17630d8"
    sha256 cellar: :any_skip_relocation, ventura:        "7df2f2afd9fd501ef0cad9662e28d0d528331ea40390b6811cba45a5a31f7a9c"
    sha256 cellar: :any_skip_relocation, monterey:       "79057fce4716b8584b3936048ad458dfb776cb9c21e4feb7b8ff5de56e0f15b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff638ed659b67c0fd6d01025a3b5e4427e3525f58852f73239eae0901344f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "547cf0d372f01ceb6fb6a69b10925acac9239ac547dcd64078cda4217e23e83a"
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

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh"
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: operation error IAM",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
