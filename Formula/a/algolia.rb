class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "7dd953bb70b59246e30b4721f34cda3f424d5b6461fe63686ccd52af4bbcb87d"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e48eb2b05cf70ab2c182b18c6e14007a21051a73c606b00bba0fec52132f70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e48eb2b05cf70ab2c182b18c6e14007a21051a73c606b00bba0fec52132f70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e48eb2b05cf70ab2c182b18c6e14007a21051a73c606b00bba0fec52132f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "69af07e6d5f63dcabbee22347fcaf486d9681c1a01062517a3db7e4fe93ed196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67314a506eb1b38c47633ec97657ebf7595c2b493e3d0f12775fe58495030fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a0aef7f8dc9867c831fcf9139cc20cd895ece8e79363fccba8e303ffea9381"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
