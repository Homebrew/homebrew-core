class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.1.tar.gz"
  sha256 "e9484125d5d9bdf18b41f6cc00373f9d1623c7f250d24802e517cbfa3e787717"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6033973a2903160dd9941ce5475359b10997f72a60be1bb073dafeb20aaf400f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93f1244986c9c0474d435bb93df5690773f4186eb54235653734582b7c569a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a9a3039b4e316a3775281a5b35a211756c4167d0ae6d441054d7a09f23ed46"
    sha256 cellar: :any_skip_relocation, sonoma:        "748e225b055f3b680d7faa9376568be79206f198fe4a994455d18eda6636e6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b3d48990c3f3075585c55ad60fb1e152cbdf690c897e6bfff9bc5ef1478775c"
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
