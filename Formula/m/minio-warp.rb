class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "76a69952ee660a4931406cd05d60ba6635e9baf478a1bf17da00c5cf24669955"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3da0954bcb178dcf74c028f15c1b46c06008eeb9ee93c7ec9a8645c7058fe24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dcc5fcd727591d51c11f5194da9c7bebfd56b47f9daa98eebd6a0cebde8cee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4d12a0877d7853e4ae0c1356dc74d4b265ddf67d0fa344c906c5a709219d021"
    sha256 cellar: :any_skip_relocation, sonoma:        "571c6e8582617933bcba6ba4054b50d5e3bfe866449bd7f28e59aa52a415030d"
    sha256 cellar: :any_skip_relocation, ventura:       "6ac37327c2fd7a77d0276af4787f96db92c220a5314e181fe7168b64e1a22cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e1fb688d6098455ac8afccd3fb87914f823c2b140e8085610a9f8015decc86"
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
