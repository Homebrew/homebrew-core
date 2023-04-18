class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v7.2.0.tar.gz"
  sha256 "3f2f1d0ec06eb0873f9b96b59dc70f9fcc832dc97b927af3dbab6cdc87477b0e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70a9e14c2729ea8df8ae032cad82a5acabc672b794d8f5ec0c19826e1e2907d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b045a26df28dca2b1d22d441a8cd88d394ad61d33013eb1f2fc797dd269e8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "860dc779d047035a558dcee215b8e3e83fa7b5fafaf67e711a883292064de76a"
    sha256 cellar: :any_skip_relocation, ventura:        "374a74b03844cf23e2b61e196866b20e0332a34cd23f33fc411172318493b0fa"
    sha256 cellar: :any_skip_relocation, monterey:       "76a5c33efb98c742439d8f10b31477237ae95bc53c4fed0e6ccbf89e08d04120"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa255764ed36d6d7243e8bd72c7a9cc47aeeb2622793c119aec5d00487da0a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d333ee69e8ad3828016b40fef129eb49fbe289a158ef3ede9ab08c6bcc149c"
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
    assert_match("aws-vault: error: login: argument 'profile' not provided, nor any AWS env vars found. Try --help",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
