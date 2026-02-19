class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.8.tar.gz"
  sha256 "cb94fa7a620573131a90fef4822711d95faa7f6dd50ef41f31c84c20b33b7e6e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efad3a7ad78caa1b66d556477d21d263c7cb9c08307643d0236a608680e68d76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efad3a7ad78caa1b66d556477d21d263c7cb9c08307643d0236a608680e68d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efad3a7ad78caa1b66d556477d21d263c7cb9c08307643d0236a608680e68d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc1674b65215dd6333fb546a0e720b17ce997c8b2ad22f9c24662bd38f009d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59b957e31a4938919d626ecf20103ccf9ebee47f4195861b0d6ee21f2840d483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d23a529d366462504476aea55a833549deaabce5da9acda44c9b05c1a3b00f62"
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
