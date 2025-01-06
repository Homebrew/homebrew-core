class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "29069213b2573855a2716346085972d0936f63b71549848d8ddd29b54df50441"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f263dd36e7883f406cd8b3cd265345289cbb4b2fb328e8120f82b78c500506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd0e51df85b9ced61fa4692c6fd3774b35c49c85b114668d17686507d58001b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2016c21945da04ec5d57ba16593538a86236c607b8c62178eef0ebee9782a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "402e9b24cdfd08bd6063f9b98141c6c30d46c73b72855b0525fcaa8ece6de569"
    sha256 cellar: :any_skip_relocation, ventura:       "b4e29f816d818bfb3ca0000f23ac60cdbd338a992796218bc95e61175e8b9e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c440b0d4657c58499211f024833adc0a57372ec89308a7abb2bbf6fa4e9352e4"
  end

  depends_on "go" => :build

  # fix `list flag redefined: metadata` error, upstream pr ref, https://github.com/minio/warp/pull/356
  patch do
    url "https://github.com/minio/warp/commit/5484b972eb3c29783bccddac0c047d59000c94b3.patch?full_index=1"
    sha256 "dabb945197aed1ae1be67baf442d0dd75a6f6c5abddf17485a596176cce25620"
  end

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
    assert_match "warp: Preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
