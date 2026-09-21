class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.23.1.tar.gz"
  sha256 "bf6c5661320cf0ecebe6097ea2a6de698b653d3fbdf14d4f19711d3d5b66612b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "020bcddd9acb95d9d3b5013921ea8024748188cc68990878e63f4227c013a072"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c5c408678422b7e3b31f6fbe1e06593dbc9c09b344af9dc81ad2b417c1d6334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6f2a3552b46bc0139f910c3e365d7d4da485fe6cc0a029dff29dada7e05b0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1e718616b0d46f97f87917ff0b066fa56fe658e9db93eb9cb2712a5a2bbc057a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "580b6d030e788a6a4040086c2f9ca31609b47c0df773a133af0c5d28bb5794ba"
    sha256 cellar: :any,                 x86_64_linux:      "8d82362fccd13fc3b72b4e77f3c0a3864533ea6e3b203053c14f03e1483a022e"
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
