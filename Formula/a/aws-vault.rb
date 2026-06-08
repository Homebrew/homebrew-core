class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.11.1.tar.gz"
  sha256 "481f27a774554e2c7457cedb3c371ace73f97e5b59eb59f6043847680605bbbf"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1119168ef3bf67139a3b4949ee3088eec1a02964e4cdbdfe50b9504024b1d9f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985c0d2e2b8693d05f78eca22d8a93766d8e4c57262557c1462cad9d88909466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45206458665a1b59ee18356221955fb726a9dbf50cdbf8ba348431d97e18ed90"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d85e361b5b75db30ef48fe9ab9ff6d39bedcf0837e92354138d05bbfa0f026c"
    sha256 cellar: :any,                 arm64_linux:   "5991d48cfa5ea99b0a611b0b2dc7c05bef1258ffe7e75c1102d7ecfcf95a46cc"
    sha256 cellar: :any,                 x86_64_linux:  "684914e57187cbf6373cea3dd5613f7ba67d67c20ef61d7160a4247d583285fe"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version}-#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "."

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
