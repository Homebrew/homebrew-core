class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  # website bug report, https://github.com/snyk/driftctl/issues/1700
  homepage "https://github.com/snyk/driftctl"
  url "https://github.com/snyk/driftctl/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "30781d35092dd1dd1b34f22e63e3130a062cf4a3f511f61be013a0ff2a0c7767"
  license "Apache-2.0"
  head "https://github.com/snyk/driftctl.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e1e9c8ecb8968ad121f735bb0caeaa299f0c672aee5ff126f75c5e995c60019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e1e9c8ecb8968ad121f735bb0caeaa299f0c672aee5ff126f75c5e995c60019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1e9c8ecb8968ad121f735bb0caeaa299f0c672aee5ff126f75c5e995c60019"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7d1581a548ade3dcb12fd89bcbf8ed88aa5da3ea34d6a6b3d70aa1889328e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebdba827ebd29a059d3ac3f976e2a7f9ad2615e19c7e91ad69a4423bb489441d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce678543cb2a70b2450370e87969af8c857f2fa3218fc0436f2c36aa7fb86855"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"driftctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/driftctl version")
  end
end
