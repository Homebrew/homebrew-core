class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.24.0.tar.gz"
  sha256 "ca0c2bb548a96764f09df4937c62f82fa728e3b7ad66086a0654e5f18b2d25a0"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bd9f2529a2f0ce6e3b2563251459edf04e439a3c8c986f87dae6dc9ea8f852e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3727b4c0471fad447b56e8682c80ce3ccf002d60ab15fe2bbee9000367c5171d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36e17187518d0b92c5bcb3750c04be57710cb362a52647c9358540176c7d7528"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d14928549077c5fbd072b04df77f81c1a079684575f83c679fc2b3a6ee2fc22"
    sha256 cellar: :any,                 x86_64_linux:      "0a4cb29ef6bca5ed65b4fe728d77ee5f375eeb3913e6a1131074356038355387"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
