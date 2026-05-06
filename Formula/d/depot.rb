class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.56.tar.gz"
  sha256 "4e1a6195f00dd33a7b0fc5df07d0cf11fa2b44ec3c636dab01da49d0ef7fd8b4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33ab2e4b14b4c05aace162665fa99a6355bc3dafa2a5e79ab0de13938e1e4c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ab2e4b14b4c05aace162665fa99a6355bc3dafa2a5e79ab0de13938e1e4c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ab2e4b14b4c05aace162665fa99a6355bc3dafa2a5e79ab0de13938e1e4c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "021347dbd06fc781d6be29ec41802fa0f5995ee011db3bbf7864308a2d46fa2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df59ac32e8d7b0b64526f00ede7eb12ac7895f3da9eedf3948ec794f88c8f180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac05f046096c1ae4ffa53d1b47ee0d97c759de21b6416db671d1a189d71990b"
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
