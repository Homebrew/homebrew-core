class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.7.tar.gz"
  sha256 "17e180b9db9b6694dac7d021d9cc283ff18c552e39d0ba2b7b0d98e866905da2"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ccff296dc5ba5a86dde04c1152664e564af506ece6cb3c723fea253e0eff46c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c31fe601eb95064e32843aef368302273d670bb003fe9ef8a4089928aae43afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c469a610deb32f9cb5baad778e042fd54548e34bacf647e96bb512fa1978931e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c0e21de94c87486b9d32f2d3d28b61e80335f8fd8cfd7ae29d990546d03b3da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d49ff8e46ce66e206e420cb7bec6f2447165fcd227f45bbdcde07a81bbe318fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065f592eafc2a74b44684fc470a8e62870216f0fe22412159e7a59e16e0da706"
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
