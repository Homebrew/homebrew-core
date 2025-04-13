class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "567aab773f0cf27aa37a9e8df5d0f609be0a0a3a41cb9ddee9255b2249152f75"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb99932d941444df1fc3d1ba1a267adc6aee55b0eb0099d2454dd5609ad2d82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f2c8111b08ea2caac2cd982910b64823ef6f56eff448e366218adba26451a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "003be8fff7bceffb44772aa3dbe2c176084c5f434d10492058585975116876be"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c74de0d3812181974bbc2b753753eeb8d10805bf6cb58c4cf77db14c58ee282"
    sha256 cellar: :any_skip_relocation, ventura:       "bb7372298656447aa37f9626d97809b85e9a1a4f54859f67131486ab945c7297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70f01e4d457b6f37fcd81327600e6b4b8d59e0759557dba415315d63c9bc9353"
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
