class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "9eb469f5ec8f114a8a3216688540792bb26ddf12365528eb928a5f922b706337"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8738f97588375fe4bc1d0d56e1802d16f6750cc582ed6cd296b3608f5ba6c879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8738f97588375fe4bc1d0d56e1802d16f6750cc582ed6cd296b3608f5ba6c879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8738f97588375fe4bc1d0d56e1802d16f6750cc582ed6cd296b3608f5ba6c879"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde960f33c82d83c3c2a2c79b00f564edca4ffa0d02091026ee16c04edba1a97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6070135195ae1b2562ec5835b977f0df828cf0ef9eee37dcb42e63523d42e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4a15dd1e648d49d126e683e80cb0ee0d911693c85d6a9b30dcb595a4231dffa"
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
