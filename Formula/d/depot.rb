class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.8.tar.gz"
  sha256 "371fe5c5bc9ee1a711022065f2e7a38104c354fd7e1ca99b17453b0b969d9362"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "771991afa9d77d9939c9453281f0250477ff68912d12af555d505cee93a6ab6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "771991afa9d77d9939c9453281f0250477ff68912d12af555d505cee93a6ab6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "771991afa9d77d9939c9453281f0250477ff68912d12af555d505cee93a6ab6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a20563155b0e55c79e7a4e0caaf06b69d116ba3b499eaf1223dd55c4ee67b0f5"
    sha256 cellar: :any,                 x86_64_linux:      "106225d2fe254df75edd0716692b847bba97126cfa55a35700b279447ae07a1f"
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
