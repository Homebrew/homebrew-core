class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.29.tar.gz"
  sha256 "5037afa408e6e87ad2db669e22149d453e20fac60c8e5547b6f4ba0fa129a5a7"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4967bac41a472f30eae9f2e9933d539be3451c8658adf18a4c0d6174fec9d70f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4967bac41a472f30eae9f2e9933d539be3451c8658adf18a4c0d6174fec9d70f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4967bac41a472f30eae9f2e9933d539be3451c8658adf18a4c0d6174fec9d70f"
    sha256 cellar: :any_skip_relocation, sonoma:        "20fec2ab58b4a1a7db1693b2e9754136bf748475578c8aaab4599d35450f9c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "156f054e69c6fda1504858f85607bc911c44dd076573d84a1f4ceb18353584ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34cf65c9464b4ea5e4c1b59710e462a20604b2c3d3b55da4779b5e7849ad6cb"
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
