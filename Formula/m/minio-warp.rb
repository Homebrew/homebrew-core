class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "f6afbc9d889a34f86459c40b26dbd901879be11e7842b98273a6af2af03dbd0d"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42b3d9152e3325a0ea9bca93ee0b3b88889ac46d285a2e6c7c14ab54e4271202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b753455be912312a700c293fdb16c8dc49799f881b1c3f3e1863c8763b1882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1f7041dc9b4d116376715698ede7cb891d8aeae9d15b8500cc7f2fa3fb017b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a72efc2706845c5255751a36020e688baff26c85d05897804f6628cc7adef756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df5038e54b7abedf74ef77873ef2a77f1d023a14649cf43c0369453f445aca10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58022f6ec4e73ce0bc4f52f84add268c7f996cc49d4d733a285b31489ff1934"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/minio/warp/pkg.ReleaseTag=v#{version}
      -X github.com/minio/warp/pkg.CommitID=#{tap.user}
      -X github.com/minio/warp/pkg.Version=#{version}
      -X github.com/minio/warp/pkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"warp")
  end

  test do
    output = shell_output("#{bin}/warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
