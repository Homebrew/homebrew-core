class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "3f2f1d0ec06eb0873f9b96b59dc70f9fcc832dc97b927af3dbab6cdc87477b0e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20f344cb9d217bb3f6e633e651dfa98840ddd931a00837dba9c81c650c210be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b0b3c72c3b9820f1856d16e4e22a4c90bb5bc9a25a790c4b4b30330bc63fcaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d4edf5be0c041f46ebac1c5cc20abb955d39b7da6a995f9b12dcf3cd3b3c0b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da422ad42ec1da2e988d334eed3f5c10e82a7eb74a6896ffcdb324925ee9d43c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab8b714b99158dba0a3fdbe10a5c5c0abfac2ccb879f5f276b1859b4817487a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cbd3ba6f0c5821efcf11d31b68894b3e662ac2459c146e35a5508c1dd520d15"
    sha256 cellar: :any_skip_relocation, ventura:        "093f64e9b044016512882a0c9c54676abea5e3a9cdc997c2731a8549b2296e20"
    sha256 cellar: :any_skip_relocation, monterey:       "25c992b608cc4446f0776d145e155c434d9e4c13abf4f76fab5a87ab62eb5911"
    sha256 cellar: :any_skip_relocation, big_sur:        "0377d6550111f02593a073362568c0aa9af51ad7b586bb8e86f7a3756bb4e26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c43aafd7b0b3408d286e2f043e9007e261d1ea6df5a2c0fbceaaf909fab18b45"
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
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: argument 'profile' not provided, nor any AWS env vars found. Try --help",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
