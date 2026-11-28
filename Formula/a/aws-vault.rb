class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.19.2.tar.gz"
  sha256 "d28a19cab795a1a0bc4a8114b15d20a523aed6bb706ea4a3b71ab1422b33032d"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "c7b2d9a1485e18ea2323e7c245605de7fb6e89561a5b2dfe7456d2b4c19fac2b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8cc7ef7d766885d16832ce4039ffe8ef1114daba996a00242916ce43c6504e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "015f16c5db57b045f1f3c7c5dcacce4fcf1b5f7d01d67268b55cda8726fa0dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "842ac9405ed03ad8ad0d8f02016cc664dc71006e8b1c4cea140cc201a83217f8"
    sha256 cellar: :any,                 arm64_linux:       "0d5f2d3757c503935c51e5d99cb8560b7bf965f4c6edd5dcd886f93007d707e9"
    sha256 cellar: :any,                 x86_64_linux:      "6e0cac3b21e967331229031ca1305f0193df53a08b5fc166541a889d7599e746"
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
