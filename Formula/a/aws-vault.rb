class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.3.tar.gz"
  sha256 "64db2ed411e8f23926865fadf755ddf786aa97b6d415a6926a38b33d50012094"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0af8892793dc80279e149f4915029c1ca7444c5c34a43fca28a625bd09d254a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed1abf4f9cce4a6a53001aec39c80d3cd349b8199b63f67222dcda7584e9c5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "286dd112e88b0eca623b21c2f37874656eaae2fe9a9a919ce8a6420fc0e9b84a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bfffde460bdb24df48c64b5b825c9ce9c80d3c3a99eec8991a00dd71a7639e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b8d28abf0959601c38dbf9efabc6adac6ef319f0abbe55ef500b0833b8cde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71727e06264ebbd0cf791152bfcc0136fab8e7f8998c67b2ec61a060f3391a4f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
