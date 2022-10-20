class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.38.1.tar.gz"
  sha256 "507731116447958ebcee89e3fa5e6c476cd5afdb3c10c7be414f5d55efcff647"
  license "Apache-2.0"
  head "https://github.com/snyk/driftctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3185e7d1d585f95d92c48ca466140f643058152640814e862d6b26465369d5a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e7d73e037760516643a213e3f1b52ca160cc44cc11a6ab60e1666e8481d16b9"
    sha256 cellar: :any_skip_relocation, monterey:       "66d1d2f0f3e7014249cfcc94d14b030a0714ae771d609d325d4cf82636cbc0d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f472a634ee743b42e17237891425ef32099e1e1f2fe252f7490398b5ba1fcda"
    sha256 cellar: :any_skip_relocation, catalina:       "588b66574960f283bcc2f9ba31fcce5395abb85213c52077c40006b579e27af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0616c89cde99c342c357f80a2cd31b12d478d3a6d10cb187355a38b835422e2"
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
