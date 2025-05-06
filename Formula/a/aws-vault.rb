class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "3f2f1d0ec06eb0873f9b96b59dc70f9fcc832dc97b927af3dbab6cdc87477b0e"
  license "MIT"
  head "https://github.com/99designs/aws-vault.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d977e625b3ac401635b1d95b4b18e4fc0b058f251f425c102b7b965e08b2ecf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e85192e42b17524b0a1321b1d69beebfd2c0a10baf961e514bce2914eace59f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "578a68527779690f0f37b655af958895f8b6d854a34767a263dcf5a7e7a14e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d404644b13dc1667c7ccf0912be79ea2788cb339773f2e350b0cdda9d1f7d5"
    sha256 cellar: :any_skip_relocation, ventura:       "a1eb3f660e906283eb1d48d6c96b1f81a10060f7d0367735b219f3c103191921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61114565f6c9bf24fb99520e20f46494517ff949805299d178861e8e24b59d58"
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
    assert_match("aws-vault: error: login: argument 'profile' not provided, nor any AWS env vars found. Try --help",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
