class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.75.tar.gz"
  sha256 "29ebe8881722d4a8a6f20bc68b09ec9e8ae986c155679e4495a8afd8790ba969"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f227f4ec9399601dbc8c3ee2258722f9e6541ccc0e2a6e7d771e8b8b95f4bb33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f227f4ec9399601dbc8c3ee2258722f9e6541ccc0e2a6e7d771e8b8b95f4bb33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f227f4ec9399601dbc8c3ee2258722f9e6541ccc0e2a6e7d771e8b8b95f4bb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1daaca11ca6762ce87bdde99f01324e7cd826a47e114f41590a71c99f66b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc84e0e64d5ddd3fdc6e49ac930291b7c05ca5220ab595c682736c82b859d5b"
    sha256 cellar: :any,                 x86_64_linux:  "14a219c99da2cf07d4f3951ad5dfdf5b2275e0c24aa727e5955f57767fecc65c"
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
    assert_match "unknown project ID", output
  end
end
