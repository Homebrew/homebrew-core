class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.6.0.tar.gz"
  sha256 "c9973d25047dc2487f413b86f91ccc4272b385fea3132e397c3a921baa01c885"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3c89b705062010d9f6667bccf0fff48fd5f4d8ed1a285a2a5d3f5071fe6bd07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4e2c997cfd3b046c6f59f8c44c9238b0366f3def9af6e072d1d61e873b22b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2e2b8fd4d15fb66317a03419359508261edaed5bb01d050b245908b9267c33c"
    sha256 cellar: :any_skip_relocation, ventura:        "103be27e74361dc49cfef28552ba619741ac25c1559fde0334f9de394abfa308"
    sha256 cellar: :any_skip_relocation, monterey:       "91b9630e814878adc85e7357dde03cf5d6753f943a736c1697a1044ec65cc0f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1e4af96ac99a2d4774d3dc30bccea11c8bb9eb8c93bbc60a069ca98106c617f"
    sha256 cellar: :any_skip_relocation, catalina:       "92a1a53fc9431d199ed2ca1f7767e20cb93177141af52e80dbeb1c3b7afe4716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6a22003f48ddf6c493440af96839477efd25ca8e966437a8f8cac25e651c2a"
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
