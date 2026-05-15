class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cf1f16c612ca72af01b0de2b30a79486e7d03c4da7cfba49e142265eb550e0ba"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1de21beb5507c561a4fcf56462cbe4a4b003eb1d7635ebb123fb29a9f217615e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717d02e30f1f87a521b0131a7063dda96f4ca264d422ca2ccc0cfb5c0d7bc447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f38a5096a886320866fe201b71d1a159398da0e7b38f5863abfba30e453d7369"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a02937872a206ffa7428bd254877769786fa06f4f57a32952ccdb946dac198"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6f14ff723ac43caa6f4bcb281cad9cf9507eed32dde1ba128dfcad9a9dfb31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972b931ebd7e4fa010d029ed8a651046a61a4aa15e5e3c40a1ed75dfeba4f38d"
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
