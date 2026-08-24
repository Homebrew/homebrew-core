class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.107.tar.gz"
  sha256 "a7ff23773d2e4efff8a93f6f8ed9e1e85f1cbf86b6aeae0f205a1874b2d47ed2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69c268c123d3784f8bd850f03e04f8408383c6d1bf7d7301afb135578f091672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69c268c123d3784f8bd850f03e04f8408383c6d1bf7d7301afb135578f091672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69c268c123d3784f8bd850f03e04f8408383c6d1bf7d7301afb135578f091672"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25e4b1668e40ebfc0a68d28f3524d991617c334fa251f2746cc39d1f02948e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3748ad4001d27b51a8c68de355f7cc6a115cc5a3aab9be3fbdb81404d02ce145"
    sha256 cellar: :any,                 x86_64_linux:  "53ae7768807b53827dcc84e33c0225b84f2e46d5b48036355fc51c08c0524196"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
