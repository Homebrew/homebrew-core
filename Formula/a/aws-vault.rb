class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.11.tar.gz"
  sha256 "e791b426f92d20c54b81f5aaa63b3849e31d3ae55381619f38e74908b41a0022"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d478b2536e18c0902a67c4508bcd7cdeccf725a4ce2a30841ee142e3861041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa1b5027b34f917ccf9e954d1a4293808fe0813ed0d8ee881d711391249a968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23eacc3709ff03772a12a5f8d62f0e054a0294ade98d78e2ea8e46539781d8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2030029311d9478cba9758ee93c76b1d039cf4a1a0e6b07255663de1286a102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d095bd56ad372e9aa0242601075c458be442f5279f6aeec8e62c08d0580a480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49536093ae34438afb6924cb5280dbe7ba260272410031b878a376f334bb1163"
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
