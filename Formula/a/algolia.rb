class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "da07db6fc57def8d8181a782cd0c384b545d81c5704dcb4285d399257370cca9"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "950bd615c19f9fc7d56dd9b2e81e485a9731731090e03ffa2a669907caf63d7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "950bd615c19f9fc7d56dd9b2e81e485a9731731090e03ffa2a669907caf63d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "950bd615c19f9fc7d56dd9b2e81e485a9731731090e03ffa2a669907caf63d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4494af66007ad7374f083191ba6fc6848e4a146d767a27a45bda5d49840e1f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f856092a1c5a5246e15fde1d3441f73c27b3bdc2af8a9913783358612be48dec"
    sha256 cellar: :any,                 x86_64_linux:  "7d4ed6d19749f08e4dff1b54250133cf57c44695320f921b515d61cbda2194c0"
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
