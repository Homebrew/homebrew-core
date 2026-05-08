class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "1ef64673757765a0356e009d9da9b9f80de3ac94b636448fa4a4b107a47238bf"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f67f0aa4959b7bc9846ff3d7e363bcd4efa3c807372aa02fbf9aa9f43219a4dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91483a809678b48707a06f57a903997625108c76c5807980d5a7b3ddc3ef4fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "568a90696357a169e0077230167a8fd606c05ebaf7fafe7998189c861dd9d78d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6003da01239cef91c1b69630b2fc25b03deff148cf2d776eaf251d646fb28d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1edb9366f0b967f0a4b669828201d1b7e2c2ce26db7b0b0d9162b17c739d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0fea85b6defa1c850a2c083ba4b10bb60676c93427ceecf73d54c6f28dd4a13"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
