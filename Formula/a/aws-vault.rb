class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.6.4.tar.gz"
  sha256 "dd2b46d06890f77cfd7e9dc64f58d227290af05b0415a14bf637f47bf04aaecd"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2637b3348e0e398f4bc961996e9fc82063174f82ffb20bbac76a3fdda1c15761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c247ccd44a21c917b73dd0b2ca09a39cae058bed7283fc52fd1beac0c9e1c177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c4d7b312125da2530eba267a71504b15ea661c3ed741408cb94cdf369e318a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de8a03c21c9e979ec97f1ade9f9688e75833f75c8b17c7cb72a8c691a5c91991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff338d150e24408e5b03c9db8da3a139c5d79a3ff2fcef74933a4eb8207ee8e"
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
