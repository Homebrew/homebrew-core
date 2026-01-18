class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.7.tar.gz"
  sha256 "94ad51b78f62da1ac7c4e5d88ff84e3bf9f9fbe18ede0e04ea449d55c4a3e4b7"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be2e4abf974fe460866aee5be814e94549bcab4c932b820bb76e3b96385ab3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "937167117c1a8445ff573cbef0d32ec9a4e10083516f1e584ff90cd566378f9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33692ba458739f0f133f55cf602b3e5c7f7f9449d4ca767db711a501bfa22e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5824b1b56b971cd6a157fd806fc06c1c7cdf60e1572b06d6c726b3c3862a10de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00fdc0808a6d2bf8dc0e4f64a7c2bb697b32890bbf10a8b07c4cb5ae6ef7fb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5202ecbd7d46882da06715894d61a768a4e7a5f1bb233ed154f268538e6fea"
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
