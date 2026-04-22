class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.2.tar.gz"
  sha256 "240c4ec2c96746d32e3e860b462daf92967d193a2b1dd1f526dd188a679386d9"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0bdc628abdd807e526298a5f3028f751971a30672787ee6e4801a0dff76e1ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0b0225c69e60b69f63335f0a64629ed14fc2970ff7032a54db47694eefcaca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a7bdbb259a529b2862c647f90633ed0329a265fc1b689e594d78766072707e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c92d32e77daaa815be3367a2b536fa5fc5526fa59b96d88e39d313aa692da579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d44cfb344ee97d4ee81382abb881fdd7d698e4da69ce2ad4307efeaeaa4f15f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68bd346fe387e97406b8a758b9e6dd60f9a45a827e1e3aa688f8191516db3a2"
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
