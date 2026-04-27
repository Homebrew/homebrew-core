class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.75.tar.gz"
  sha256 "2e2c61b368673b3a9664e508bbaafff6674646c5c27b6313278034ca191f6d20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "241d4e76e6c23cc0d9824f4577d9dbb7fccd4d5c8f7bcf67b67fd5a852dceb71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241d4e76e6c23cc0d9824f4577d9dbb7fccd4d5c8f7bcf67b67fd5a852dceb71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241d4e76e6c23cc0d9824f4577d9dbb7fccd4d5c8f7bcf67b67fd5a852dceb71"
    sha256 cellar: :any_skip_relocation, sonoma:        "261c22299dafa19e1b3924042319906d1eaa49826d6d8a10494ebb577fb9e977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9caa3d5200c1b6472734b2747427da221e044e7e6fea3059f66f55c012dd4d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feab1811c80bcb11bb79bbd319f682137d4fd8367ab6469d3609643db9ea785c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
