class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.72.tar.gz"
  sha256 "3c6d2bfbd5c5d075d69495b1873cf80dc4f0d698111f18f9ffd02f9205150fdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bfc052149ac80f2ba007017c618014c39491bc06df467b8d8869317a8058969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bfc052149ac80f2ba007017c618014c39491bc06df467b8d8869317a8058969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bfc052149ac80f2ba007017c618014c39491bc06df467b8d8869317a8058969"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a774104a97b4ed487b108bfe7b250cf7c33229f4f65b6ab2d6f854cb5148dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5f9a1de3d8a04474fa3a4fed8dd9950cb7893941019a27a5da9b9e86a37887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5ad10d1a902f2aa0311d41251f22134be120a708473b0a9d4ef667dd00ed1d"
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
