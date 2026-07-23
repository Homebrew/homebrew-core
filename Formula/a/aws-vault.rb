class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.1.tar.gz"
  sha256 "9f3d060455b31b75114f0cb95a2baeae2c41105c0b39c356f66faf937a47f692"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fee0044e0ef5ed7b1311d741cc703e919273468012cc979c9929ca2302ff7154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43c612452ea7d5f6a25be5a72cefc76031c287a5453c865146d2daf39ce0765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e26d21380794e749c262d0b20c8967d40e71a18506a250ce8a3630d34dd3f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "5636700ad9fc28eba03aa9a1fb0370e35329fb01a0b4b743a2e697c32752679e"
    sha256 cellar: :any,                 arm64_linux:   "88f9ba166519970fa628ff4b4955e879ef87d14547161a603c3b2842ad5c8de5"
    sha256 cellar: :any,                 x86_64_linux:  "2bbec199d049beabe7cdec0ec177f4786edc04b1e4f4434ccb08756adb83541f"
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
