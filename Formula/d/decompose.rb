class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://github.com/s0rg/decompose/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "31291c2ce93955bed0f85275c388a7123f2b23c83cf63df6eb4fcc37749daa05"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a100904be6e9d1d5d865911aeaea94bbb1ea962987bef525b982392ccd0de796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a100904be6e9d1d5d865911aeaea94bbb1ea962987bef525b982392ccd0de796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a100904be6e9d1d5d865911aeaea94bbb1ea962987bef525b982392ccd0de796"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0780566e660fcb014ac2965c82d9afd57adc20b313b3b44640e3307a2412c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d5f62eac6e02f0ccac5576d178cb608800de3f2bfa04b3b42468e59ac68c72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81bfe4f25894836ebfa7e8b0f0beefd9e8d8d04543a345b72d29a6ee03e1312"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end
