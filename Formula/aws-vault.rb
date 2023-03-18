class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v7.1.2.tar.gz"
  sha256 "87c6d7f01fb46a7e3ea362ab77ff8d8cca2be84ad0caf639807270c1a99ceb44"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f676b161358fa2eda85512d818440bdeb3c57c3469c62455a7f6a494785472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9186dcedad1bef1917d4211a9985a0902271651eaca06cf6faa4c078f2bb3f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e78c288f24dd071720e38a7ade3db420a89203f3cce037589c692bb5ead5e16"
    sha256 cellar: :any_skip_relocation, ventura:        "330d3a058c46ae3f2ab62afff296e5f637454284d9ebed83d07f18620d33a241"
    sha256 cellar: :any_skip_relocation, monterey:       "494a67363884344d42b47061813068d7434bb37c7ccc0ddddabc54be742e76c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "eed73aedd867a4ed52e441784613211ed3946eab09ee72ef4719abc9324ebfb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90540ff4566be644d7f52fe167f5c214bdf347c7d2553d9cd4262e78d64b3a0e"
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
