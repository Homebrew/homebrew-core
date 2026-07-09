class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.69.tar.gz"
  sha256 "e39ce4aea211fcbe329283c12e3fbb79f2a5dd477fe791fe8e5582797c874bb0"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b12c1d67a9252dd799c8a95dc7944542529a758186550d37db09d7cdfc886d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b12c1d67a9252dd799c8a95dc7944542529a758186550d37db09d7cdfc886d84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b12c1d67a9252dd799c8a95dc7944542529a758186550d37db09d7cdfc886d84"
    sha256 cellar: :any_skip_relocation, sonoma:        "728decb6a8060b1702dead3c61d0e3afc5f2b23316ce16258e4dfd4a4d1a944f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5aef81e726fef8bfd54494e0ebf9cf3ef4f932e6886dba19df14357b22d8b99"
    sha256 cellar: :any,                 x86_64_linux:  "65a317e1885a1bf3a716f078882cea68e4fff7bd4cf9116176cc08fda021a56e"
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
