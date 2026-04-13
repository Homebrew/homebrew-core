class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.69.tar.gz"
  sha256 "84fd80be58a52e7c901648f7a78a5566a12a67d968f670b49e7dc3c4c5f66f5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eaf03d9b3ebc83538cf6173c4d4ebe98e95886e302b1d4ed65d4a9dbb2f147d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eaf03d9b3ebc83538cf6173c4d4ebe98e95886e302b1d4ed65d4a9dbb2f147d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eaf03d9b3ebc83538cf6173c4d4ebe98e95886e302b1d4ed65d4a9dbb2f147d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3223733c89a767b91d5207fe2a157facbffa83fa7c708d93db80a95e082e75ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa02dea35a347a0b102bddc0df5a80bad307ad7704d680fde5e4f010f2112ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7888210ccc0d45ea420378c21b8addb5401f233a2feaf650b677fb9bf11c42ec"
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
