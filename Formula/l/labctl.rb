class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.111.tar.gz"
  sha256 "05b69c00563ae1b325b041ce2d1f5c00e06c71561d9fe13eb968b03fba07597a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "541836f5c171a0554951114382576affe7539c3eb61bacdd2c3bd8c874efdf68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541836f5c171a0554951114382576affe7539c3eb61bacdd2c3bd8c874efdf68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541836f5c171a0554951114382576affe7539c3eb61bacdd2c3bd8c874efdf68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637f3a075b7595f2e01625fb4705addec28fde5738b26329f2049c60cd185545"
    sha256 cellar: :any,                 x86_64_linux:  "f0f4bde017e42775262520efa7a50b382662191e20fe0be39e6f373aba33620a"
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
