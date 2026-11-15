class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.25.0.tar.gz"
  sha256 "cfb79952bec17e4283d1ac250194f856064d69b5960d0c8285f901f2c1ef64a6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a7d4b48eec538c4bec5308119c1fc80fceca4d41c6ca292ab0b087ca57c1242"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28e8d80ffba0ab0fa998012f93aedfc8306c132c6920b0a136beb5692bc70fd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6cc6eee2647bdb1b885eaf73c920226e1bccd5d471b181b6fbdd6bc0d919886"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a35a291b91db88d424e296399f12df5986117fd322f9af3e6a22a74105d6e813"
    sha256 cellar: :any,                 x86_64_linux:      "a832c3fc40081a3e9d6c154880cd212c663b3327fddd0029650134e15f2bafa0"
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
