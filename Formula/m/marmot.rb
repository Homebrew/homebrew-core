class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9c06cc0d0f460cb7910ebf8de45c18b242caeccf32c7c3f55b1fb7416c515526"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7daf374e207ad65f4e9138558698f68f7504da1ee5363921d3c8ed0799aea33c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7daf374e207ad65f4e9138558698f68f7504da1ee5363921d3c8ed0799aea33c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7daf374e207ad65f4e9138558698f68f7504da1ee5363921d3c8ed0799aea33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55865e302db1e1aa8225ff1bb1e6f05a8ed6896ac8fa8c0a3cfafc296c1f3d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6369b382a540f7ea36bbc51a03b064e577d89610e7262104ffd380afa6085c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9261426e07b5133be2ffccb63beee3bc0cc65bc3908bc1e00905c7cfba49ed3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/marmotdata/marmot/internal/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
