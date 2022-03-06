class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.5.0.tar.gz"
  sha256 "b2127b20a58fd75d92a2af28e77368dd9ab3c576dc73c3d56c3817e496a45515"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80407756d1e871340bc0020530f872ecd4ddd465431413ab224241ab7ffed1f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6da544cac7966d7df67b58a7666f076d5cbec4e2384776f432217f14cddd8ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "ab281a33c3c1a92f26b82d161ea9535f874138cd40c730445ba505ba7694de7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bca697b04ba521ae34957d316d6117e5f9788bb8d99b1b7f3f651f7e0f3dff0"
    sha256 cellar: :any_skip_relocation, catalina:       "c94f6379247159e72fbd525587381a173cf21eb43c10044a2f56b6327c2b59f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652f252b52cb55b535257f6d5b5ce2f84d75813090bf80237229bb5c71ba1e6d"
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
  end

  test do
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help",
      shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
