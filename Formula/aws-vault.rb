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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c252bb7b2ff9b0929f80544c713c0239b51054f5699d5fd3f5c0c5b4e1ffd5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5642d06419e9e31ce66e1377f0eea7d27aec05cfb4a36f78a4724a6fdc21401"
    sha256 cellar: :any_skip_relocation, monterey:       "862ac6a7df7366e189cc3faff977affc8821c63b97f29cbeb120d22442ead6d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "176964e06cda0a4b9d862cd5993afb60aa1bed374007bcb36d14796476762b99"
    sha256 cellar: :any_skip_relocation, catalina:       "c987a850f1b6f4fc5585eaa300e7c9df28796243b9d58fc316594df250497211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b91f307635e4221dca4e53e507c2d67ef77e052f589e0da30d2eee434a20c551"
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
