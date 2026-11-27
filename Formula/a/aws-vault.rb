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
    manifest_sha256 "c023b74b2b89db59e86deb4bcce7ebc14701512bfd4c0a4808bffa21ba190370"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a52132ed5684d75713245f4474d078e78480479c9af62237102922c3535850bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3463ebf73fba43b39674cbbc441cc5ae7a895d1786a2bb62f3781db8a210dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c27319694fa41ad4f483b69b30d79b798b63dbb17248f895af867a1702c95f8"
    sha256 cellar: :any,                 arm64_linux:       "a36b64cc3002ced311646bf40e5f0559c58a0fed83c39416324edd2dbca529ca"
    sha256 cellar: :any,                 x86_64_linux:      "1364c555c71b5657126488e299b42faadc6fc1f2202d851a8eae4d21b79d7492"
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
