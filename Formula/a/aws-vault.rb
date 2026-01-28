class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.3.tar.gz"
  sha256 "64db2ed411e8f23926865fadf755ddf786aa97b6d415a6926a38b33d50012094"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6047ff86d517d2a86b6427991b1d873ce4ad2f273ff885845d534db84d160a2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "674fef1693604b27184d54282d0107b95dc569e24076f603ab62aad166ff7175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5238435ca54e5267de4a75123042200cc1f14bc85831389a93e2b56d9ea86e1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1741c74d780d41f1619c9a765048de346b9abfe33ac8939d97303f8a3af5bfe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8501a61c6c1ebff77c2755a4fcf2a22c6cf89bc0fc9b2db56abceb2fade0b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1640cf7027e8a7e6b499cc4e4c0979dc8cb44bfd2117cc6bcc6bc34e86500f2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
