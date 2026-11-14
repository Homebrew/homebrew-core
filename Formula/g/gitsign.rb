class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "d87dbb00624d0e6874ef2df37b3bb3b3a89416c3a19114753d3c3cb932dcdcba"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "541ab7e2bc2745da306de99d48600f74c4142f2d31b7f02f6644c57e2de2fc3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb3f400070762e48004d00857b5a50e78441d2b5de49e8542f0208ae5db6de78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8db1fec475b6d26250ed5d3bf0181090e4c7adbcd71a262caa6d077de4122b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d83e588401b06b14dcee0f11c9c58c7000086287c349c0ce9a4135a10b92e9a7"
    sha256 cellar: :any,                 x86_64_linux:      "b65b887928e3538c90a1bccc152b6f7633a6912f1664d68eb468761f6c6529a7"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
