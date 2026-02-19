class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.6.tar.gz"
  sha256 "4e351831875e81a2289d86299eec5dd681a778e0d96e6d2728e9efdd67887ee0"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bf4d6db80ffbe16087a63d784005ed3bc32bc5352e8a40ad4b5b8327a7f0555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31c48016eb4a5d55f722c8dec7042884ab62c61c9e19b1f37612662674267925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73754229252a56c7e883a8114344ba49e5c75a70316bc9baac71a852ee5ca11b"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ef41da47d726cfc71c99c24d261fa1886aa18f8510f693c676a8fcd066f59b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5386d37ebaeca6ef68d2ab96970e88fa918f0f911ba7a57926095d89e104f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb19bae855c87e67fc99133df087be8a4d01cb656301d71a980d19a0b9535058"
  end

  depends_on "go" => :build

  # bump touchid-go to v0.3.0 for macos-14 compatibility, upstream pr ref, https://github.com/ByteNess/aws-vault/pull/300
  patch do
    url "https://github.com/ByteNess/aws-vault/commit/0dd90c6f9935ad84b528be78149e39b1bd683bd4.patch?full_index=1"
    sha256 "238f4f2cd029e8ac2dd418bca3999bd6f41575960a11089f2705059650449713"
  end

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
