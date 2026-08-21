class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "427c6bfa56517b40c5c8a150865bf3e5ae635c7141ef11e71e799ff882a44304"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffb1ec925593ce48faf134d9e5e4a266bfe893c3e914553c748a1052e75dc51c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d64fe71b73005f9e72cb177d419f2387b7c19b2578b3d27f79bcb802812f5a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627e4106c1a8ba98434c691a195286b6d7cf7fcaed8e8a849c49bbd1a04e29c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "086c8f651bcec9c2e110091630b83e25e31329145312788281de7f47a87af06d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f6cd56a4c0eb897e606baf910a76f039fb0dd93706f5e921f7a088bb6b05f0"
    sha256 cellar: :any,                 x86_64_linux:  "a55920c521f91478b8e76d0c16852800ed79da6ec8004a0accb0db44285219d1"
  end

  depends_on "go" => :build

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
    output = shell_output("#{bin}/warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
