class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.9.tar.gz"
  sha256 "3abf6fbd5d328cf9daf92b614a30b5741dc6aacadb4ad87726cb2fbffaacb415"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e641f75f3f3c96a2070bf45ef6aa1dfd60ce57bfd737bac609dfc8b39fab4386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f6b28e12be0c1e93ae666effb4c7e6e7150b19429d07e693f391160a329e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97e737e99103662e47d42b2aa07371dee79de2f0ac9d95a23a88d83d4a2ae7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7981286bf90e4407b9eb78191b73381cd56110d3260ad1cd3067ecbca7d5328d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a16d6aff4b88c54a29b7870c15e31eee640c7b49da8d18389501ed113aa545b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa2db9e4d67bc5ab306d99efdf61e02c808e8d478773447b2a527092a283f91"
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
