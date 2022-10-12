class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.38.0.tar.gz"
  sha256 "87243051a69d8b9f4d241fd1404daf6727a4124521bf312be33d5377a5eb4408"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d60fcea535fcdcde789047ab4f29bb05effd38865fbaabd0b9641073d9d1dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d60fcea535fcdcde789047ab4f29bb05effd38865fbaabd0b9641073d9d1dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "9725833cb1dc6513ef37495f94e4d13eebbb40b120ed2883e9c617b60b700829"
    sha256 cellar: :any_skip_relocation, big_sur:        "9725833cb1dc6513ef37495f94e4d13eebbb40b120ed2883e9c617b60b700829"
    sha256 cellar: :any_skip_relocation, catalina:       "9725833cb1dc6513ef37495f94e4d13eebbb40b120ed2883e9c617b60b700829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7cf0f3521517bd8e32a7e905e4cd2c0553ccb31949cf627f813c9b8e8ba6156"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"driftctl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
