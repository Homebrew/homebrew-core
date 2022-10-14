class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.38.1.tar.gz"
  sha256 "507731116447958ebcee89e3fa5e6c476cd5afdb3c10c7be414f5d55efcff647"
  license "Apache-2.0"
  head "https://github.com/snyk/driftctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "117562ecc193e231cf54ed318ff3c5bdcaab52e8f94e712de87f5ecf90147e91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"driftctl", "completion")
  end

  test do
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/driftctl version")
  end
end
