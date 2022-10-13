class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.38.1.tar.gz"
  sha256 "507731116447958ebcee89e3fa5e6c476cd5afdb3c10c7be414f5d55efcff647"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30c13faa3e8200161f5de0e52e003f2277e96acfe6581d1880e9b6823c59e38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d30c13faa3e8200161f5de0e52e003f2277e96acfe6581d1880e9b6823c59e38"
    sha256 cellar: :any_skip_relocation, monterey:       "68c627b983d7c38f78a45cb4a2b6f7a0b08af4e5251c3f8226ba316b3efce55b"
    sha256 cellar: :any_skip_relocation, big_sur:        "68c627b983d7c38f78a45cb4a2b6f7a0b08af4e5251c3f8226ba316b3efce55b"
    sha256 cellar: :any_skip_relocation, catalina:       "68c627b983d7c38f78a45cb4a2b6f7a0b08af4e5251c3f8226ba316b3efce55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3f5d910402dfcc99d637d63254f938569a9a053715b6bb5062b0ac5988f585"
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
