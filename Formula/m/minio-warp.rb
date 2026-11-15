class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "e126f204aa5f8362945f0b3ed77bf1899725d35805c64006201f747125aa0bf0"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3d7456bab46acc9ebd46f7d01af8494a9a579227aafa85d72d2d034c425e764"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b06032bc44ad42f7e2f4321899e6a2f217ad7de16a45ede9fbf002ecac747df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76f9edc7024623aaa69bfd57c40243afd99b59abc45b323f7b2cc8c65cf7988f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34b9790509f4ddcdde0351ae817d2d5f74385032ad02fe97fff4b9ba4d43cc1e"
    sha256 cellar: :any,                 x86_64_linux:      "2b02efa4508be7cbc71581ac214e41f9528739069a1db3b9317d2f45c50aa39f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/minio/warp/pkg.ReleaseTag=v#{version}
      -X github.com/minio/warp/pkg.CommitID=#{tap.user}
      -X github.com/minio/warp/pkg.Version=#{version}
      -X github.com/minio/warp/pkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"warp")
  end

  test do
    output = shell_output("#{bin}/warp list --no-color --quiet 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
