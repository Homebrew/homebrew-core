class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.26.tar.gz"
  sha256 "78b89417192f2ca3f32c444759e43886203c46757b2e6b701d14e810c1aa5ad4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c247af061961d1e2caa374d2d171fc6ef18793534355e11491e15404436007cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c247af061961d1e2caa374d2d171fc6ef18793534355e11491e15404436007cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c247af061961d1e2caa374d2d171fc6ef18793534355e11491e15404436007cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea676e775b2a20fb7a2aacf5e7ba24a0a80f3c48eb2fa14e257e4b21d60bc1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3b908080a7bad0bcd5b681e09d8bc018f0ed370066f38fe8b047841fdb12ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2bbd08cf1874d5a7cfc34f63a679431d60927a23a5a5427bf709e9994db49f5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
