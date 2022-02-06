class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.5.0.tar.gz"
  sha256 "b2127b20a58fd75d92a2af28e77368dd9ab3c576dc73c3d56c3817e496a45515"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db07c902c6c060a2dbd6b33ed11a5c4e82de67b4cb2f5ccc84cef4def62a627e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50f27cf3d7ab124dff20ae510efebb53043c89c6ea5d09b15b7c824c4c16d525"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e6c63f8fd6fb86f6ba89bff97a4a678c00f6b0792258c00779d9d6f1f0d317"
    sha256 cellar: :any_skip_relocation, big_sur:        "a00b17a0b34dd3ea5819e50321c8eeef2b5af55f9bdd247bb059d4a10da41a8b"
    sha256 cellar: :any_skip_relocation, catalina:       "86bc94f503d57879f40b3e101101d6133fb41cd3a748a052b8de65ba3ea7ca20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54d093549f57e717f6853fbf676f3b3fbb7909384eafb689ee285821e9315ef"
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
  end

  test do
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help",
      shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
