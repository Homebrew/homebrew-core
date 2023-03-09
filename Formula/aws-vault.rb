class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v7.0.2.tar.gz"
  sha256 "b4de78755ea2032839ed5ae1c69bd1a7b09eae986da185163eef190f8e7896da"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cb1e8d04e337d6fbfb4897641644235e77a4fef2cda5aa449b99c065350eacb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b1ff81e6f7cdc2b7d646d1864bc45be0a1fe4a87bd8330d6cf274d6cea17c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46c0aa4e5e935489b14b253dcb011a395cc6cd0c5120a9fe12dee23cc46b6d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "856b161068bd628e1990e08c0e8a65a315acaba8b88915b463cc3cd8a28c0bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "03d5f0fb7fbb0733f08d640f8dcd302fd497d063ded5457f8417b2b0c1312a7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "75bee403e2aa35dc25109e15be25f9332f1dbd73da0713cf36ab22b3bdbaa116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9fd77ac42d5c1e5cdb06ebebe76a8e29f7b35169346ca1147173841e7dd24db"
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
