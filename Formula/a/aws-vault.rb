class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.5.tar.gz"
  sha256 "8276092b6526f6244b3bf8a515ad78ad1ddb5a7ab56eeaad1ac1b7ee01d4678e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "248ec27fffba90716eabb04fa0573c32f430651a14300a5e155607389527f43d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ff38cf9b49d29bbd4721d39eb30a65fc12b8a27124f7131a77f7ae071377c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99a130295ff37cc03107326a0f3eb0ab7b697c9e957a54bd94e327f43e1700ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "968ab34aeafca5a09346de52280d19859289f0f81e7c3ae36e095b065701856d"
    sha256 cellar: :any,                 arm64_linux:   "ba9c6c43a4c751ae60b2e16856dbc9e6de4dd652971388710dce692e4305a2d9"
    sha256 cellar: :any,                 x86_64_linux:  "18813b3383773716f479fcd8a76ef13bb37e6e468963bf2ade9fc3ff4757c0f6"
  end

  depends_on "go" => :build

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
