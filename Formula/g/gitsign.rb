class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "097a4b990298b4761282d86eb76e2960b703a0c6519b9da852b627075a5dd7f1"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b745bb91755d385a733a0da417a3f507d1d833b50e585790f3039159423b867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b745bb91755d385a733a0da417a3f507d1d833b50e585790f3039159423b867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b745bb91755d385a733a0da417a3f507d1d833b50e585790f3039159423b867"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc161f2d71b394dac5c5c3778cca7b4d95a2f1c4b48d44bab6f1bfdf466cfec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6214c5b303cd4c292620f3f5119aacf6e16bfff7dabcb01c8102ce46347f9e"
    sha256 cellar: :any,                 x86_64_linux:  "298a3a18eb5aabf409ad740e14515e6571c307551c303041ad25de358c6acb24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
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
