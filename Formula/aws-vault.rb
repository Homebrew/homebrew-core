class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.6.2.tar.gz"
  sha256 "46383026e6261d03b9316a094b803823a1ca538f19bdd30d1aa0135766409fb5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807421c456799d3d305da1591b1e2957562037d849c4bb279eae22f739e4daec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0cd7a47603900ab194048db74fbc12a66e0fb462614c07b22bd4a7a6f52630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f8ec9c96a4a8d509cfb5371d98134c5f84de903a8f835049ace6aa56cc144d4"
    sha256 cellar: :any_skip_relocation, ventura:        "964df8b2d0d2d23f4d172173e2a53a74b7442f8f134bb5357a88bf2b30b47555"
    sha256 cellar: :any_skip_relocation, monterey:       "3b82f51058db80fc1bd16ecdcb70cf3f9d7b59635c4be72a83e4cb1e2e653165"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5be4a8a1288b5806b6391f0f1e360c6be5f58942621d13289f87d3cb6fa5047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e0f059e2d152e8cc6028c694314803ee64014658a83472ac1f9a0486484ac4"
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
