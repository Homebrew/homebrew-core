class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.19.tar.gz"
  sha256 "dbd3f04e3cd9beccdd2fb6f3087b27dc4338ad871cc85e999a1c7334280f88c8"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49f34efc0776573b9a7e6b4cd44e997944f3f6bbc2cbfbc4748b92c7d112a8f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49f34efc0776573b9a7e6b4cd44e997944f3f6bbc2cbfbc4748b92c7d112a8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49f34efc0776573b9a7e6b4cd44e997944f3f6bbc2cbfbc4748b92c7d112a8f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3a0029969224078d36a2754859c37a65592680a875765d658afa1f0b1eccab0"
    sha256 cellar: :any,                 x86_64_linux:      "66053f66a5f0d859f5fa382cc40358dbb2ed9800d91f79286477deda37018381"
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
