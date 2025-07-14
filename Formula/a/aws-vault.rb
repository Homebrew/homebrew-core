class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.2.tar.gz"
  sha256 "18f3ae7698dd380812187334444a7739a35aff732573e419d64a8ec952692b59"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817105ae2c5ffaa8bb7064cfd68be8a97d93156ed165bbeddc6556194b1374fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69bd42813bca8ca95316509e92d652e4e2acc9a51bee82e46f5ce44ed777d02f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ea56d945371a7027b1cb055bd65d5125d507175eb19749b9a73c29f92e701de"
    sha256 cellar: :any_skip_relocation, sonoma:        "60eb738886d329390ed8839a03e209fbda64aa7d204442f4cabc5b87eb381359"
    sha256 cellar: :any_skip_relocation, ventura:       "ff058dd5c292cf043dbe71cb14c442c053c018473f414c3adaeb28ead5538eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef53727eef4825e2f2f053d97690a6952fa7f759f1663723c323503f4addaf4"
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
