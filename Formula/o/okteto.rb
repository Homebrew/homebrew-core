class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.25.0.tar.gz"
  sha256 "cfb79952bec17e4283d1ac250194f856064d69b5960d0c8285f901f2c1ef64a6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf31bf798c9f86a409349251e44db69ba227c7ff8c85e173519799410b322a99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68470625cdc86eebc03f859cd70bd9d9402c92e9f3f5fb8a2e2450d8dc153f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc949ef7a35c23a1bb5bd7098257b21603b73504d2d68e12538e85b85999134e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0cb736989472d33617a14846267f0cd5f5ea688acb51571b8d9253b4dc4ef686"
    sha256 cellar: :any,                 x86_64_linux:      "0d14899f3d85a119d22b28430a5ac87704259b76f057fd3055636aa3650e408c"
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
