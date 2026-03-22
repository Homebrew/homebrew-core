class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.27.tar.gz"
  sha256 "16fe2a1028ba410b7efc096975dd688caaa329bde486661db7d2a94a8578a9e4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d6eaf51f2326e6bae97c61e510a77244df9015f695f18cc0cbb49160a0544a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6eaf51f2326e6bae97c61e510a77244df9015f695f18cc0cbb49160a0544a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6eaf51f2326e6bae97c61e510a77244df9015f695f18cc0cbb49160a0544a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "abec2190a2ae3c63586a1352b1869555bbd9c419ecc57aaacc5a7811fce3399a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8623e8cd2901850ea71a0bca1b6c6ddc289d5548a31c5f2a9bb78816a18efe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a756005c596e2abd141538ea29a561cd1802ae05067e750ac370c1f69e6e22"
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
