class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.3.1.tar.gz"
  sha256 "433df90b7ed1cf1ec08aa75a4f1f993edfe5fa3fecfff5519574613ab0ab4630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01366f5cb889419780522547e546e19239a85928379975f45ecdd6c73a65b89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb316e4c97e1d1e3bd29fd4b3c7b1f8fa9f3c5c53716e125a32b908bf7776623"
    sha256 cellar: :any_skip_relocation, monterey:       "5d4991bcdd3735e51c1c510263abbd880339f25b6af41cb6a4d2546835f9c28b"
    sha256 cellar: :any_skip_relocation, big_sur:        "96bea08ce45ad2b3e5ab857f81ba0373c57a82887d50ee3f501901726b8987c8"
    sha256 cellar: :any_skip_relocation, catalina:       "84af267993e86cd67cb6dbe9d7768c6407837d8473d6a17e715fafa5c7bdf7ca"
    sha256 cellar: :any_skip_relocation, mojave:         "f36473dafd176d15448ce1dcaf80de6bbb460a97d8ce4ae706816b864d911baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e22ea3ed44f313e480116618673e82a043216a362da3bc9ae457687eb1c26994"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $(INSTALL_DIR)/aws-vault || true", ""
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
