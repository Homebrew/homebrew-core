class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.19.0.tar.gz"
  sha256 "7d81733c77ef8a437ff80df76db900941a202d2f8ea363689e954a34601ce3d4"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7adcf28dbfd532720c73295c76bb9714d4a859272499f44697bd226b8c50076f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "192e7343bcd54311f1cc309f910d500d8de6d8fea1ba740b80cde3bb0a5c18a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3661b4152b610fcdfaf71548ed43a5e3675f055d1ad523362d2415e058ecbb1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1127734d639bc06d354d4fd3748eb703096a26adb7d3cc077029809b1af40f0c"
    sha256 cellar: :any,                 arm64_linux:       "62c0133073a0becdb032ac5633024644f3b92a79c66aaea226016a7489286214"
    sha256 cellar: :any,                 x86_64_linux:      "0e747cc1b06dac5e35ecf6760c0bd06f52e9c7a6b25d41ad07097771723cc99f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}-#{tap.user}")

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
