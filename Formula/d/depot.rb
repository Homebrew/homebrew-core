class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.29.tar.gz"
  sha256 "3d59b76291a527c4abe25ec872571292b78d0fca15aa9a818d7fc5c0e5d6781c"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eee0d1cacc72d23089e0498d3081c28a1bc8f7266992c8cd93bb382170c703b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eee0d1cacc72d23089e0498d3081c28a1bc8f7266992c8cd93bb382170c703b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eee0d1cacc72d23089e0498d3081c28a1bc8f7266992c8cd93bb382170c703b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "233bfe1a48af68f321204cd40bb59030e1d1e7b7e80964b43c2595a15ae8415d"
    sha256 cellar: :any,                 x86_64_linux:      "aebf8a1d48bbd34ad8c85a664d6b4f408ec137cde84ca08948f2b320adf550d3"
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
