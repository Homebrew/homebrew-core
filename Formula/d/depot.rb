class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.9.tar.gz"
  sha256 "54c687336e3a8f723dacd1f3170337e220af3501b989aeac2d15aec0a3478223"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21faa70217e021bf6ccc063557cad33fa392c720a01ee634545f0dc353c2a49a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21faa70217e021bf6ccc063557cad33fa392c720a01ee634545f0dc353c2a49a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21faa70217e021bf6ccc063557cad33fa392c720a01ee634545f0dc353c2a49a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3510eb81db44bae114d7a8b8ad13455626c7b425379ef9569fa96d21c311defb"
    sha256 cellar: :any,                 x86_64_linux:      "2218061e0d84db6db206d9e853b7652b63eba61ebea143e8638ccf46efdf7c70"
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
