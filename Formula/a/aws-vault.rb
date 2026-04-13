class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.15.tar.gz"
  sha256 "e6b924a2b370021cb4e3b59f73dabb083fd5bb925b630cc211b47733bb5596b2"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83cfbafecb34d553de2fffb6929f99d168fc9348fc282c5fa0fa9233269d16ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a4db4630f3eca2961d873ea4cd36eda9b3345b9c612efeaa8a340495893a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a2838dde10d149c5ed58a2fe58467a77dea6ae02e5f6543ad2ec635d82241a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c66729b4d641b1b5c3a2d97340dd4939e6c0c523ce15a26e89cb9f53031d81d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8afb259cdd983606579ad6c3d83ae6b2369d7e0d8fbaebe394bde9c4e7442fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e5412ce1f092bd192d7b0e5c11fadae1c508103ea5a6e38d863fa0ec75e289"
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
