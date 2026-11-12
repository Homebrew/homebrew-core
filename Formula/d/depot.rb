class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.12.tar.gz"
  sha256 "528e6e2d8bc8007cc9b52e73f30de7a43fa968202cfe08a083a904799b77ac30"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91731a1bedbacda85bb8c86d06b5c26f1f47b67c8638addaa3ab5116d03a6181"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91731a1bedbacda85bb8c86d06b5c26f1f47b67c8638addaa3ab5116d03a6181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91731a1bedbacda85bb8c86d06b5c26f1f47b67c8638addaa3ab5116d03a6181"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b69e1d3647a1e26b4a4be9b52e5a17b5e9afd7c51c5dc5c4a77de22d2bd9ac9"
    sha256 cellar: :any,                 x86_64_linux:      "0c647b920797c28c248705fe97d8cb0b5bea2bf5d195596424c992c9ca850e1f"
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
