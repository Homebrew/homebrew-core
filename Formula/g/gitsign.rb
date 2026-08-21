class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "0325dc76ec9e2d8d81d96aaeb6dfde0317f6cdfc60710fbab9eb636648388085"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a2862749bcdb0b3265a178290032099fc025ce58e80eabe93028cd8550a1b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a2862749bcdb0b3265a178290032099fc025ce58e80eabe93028cd8550a1b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a2862749bcdb0b3265a178290032099fc025ce58e80eabe93028cd8550a1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d92453d5dbac80d6b43ce40a36c5587a3ae5474fb97017aaf4a65218773cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9375d212e62861f39f5233a393ef464dbcf9e57b3150922bb9575d859cd8a46f"
    sha256 cellar: :any,                 x86_64_linux:  "28225b1ebb6598c3cd16425e34d6760753c103b3f6a6e439b78618a87fade8d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
