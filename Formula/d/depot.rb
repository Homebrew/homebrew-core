class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.18.tar.gz"
  sha256 "3c90eafb506613ee52963d375771e5a90d1c4221386e7ec574183492039ea5e2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9359c27faa5c8f2dfa7e03d66e387a6de6c3e77b223d0fad6721f06f97171f1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9359c27faa5c8f2dfa7e03d66e387a6de6c3e77b223d0fad6721f06f97171f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9359c27faa5c8f2dfa7e03d66e387a6de6c3e77b223d0fad6721f06f97171f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27ca504da73bfb02109ed8276c6e3cf88931986509267cbb3832f908db23fe81"
    sha256 cellar: :any,                 x86_64_linux:      "0609687cb61254a69a4e49c0d022a5d1432fef7baa6190844d0b4bc01c797625"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
