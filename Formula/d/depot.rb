class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.30.tar.gz"
  sha256 "4fb1ea4a76f11de27a1b9684659eea619bbb1310cf7fbfb0b6f5e76841d7b21f"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aee41112f97d8f3c2cfb517ee0b22a10bf062d0727394f319de7b2f0dafebdad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aee41112f97d8f3c2cfb517ee0b22a10bf062d0727394f319de7b2f0dafebdad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aee41112f97d8f3c2cfb517ee0b22a10bf062d0727394f319de7b2f0dafebdad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97fbf30dc9cb65cf9bb13dbb2d49a0b74206bb5bb535d85476b59928b75bc514"
    sha256 cellar: :any,                 x86_64_linux:      "3e19774a858bb2752b21b760cdecb4e0eaf3a38dba8c86a04b8b9ee6c7f12251"
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
