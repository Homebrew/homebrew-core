class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "af2d45bae9702aa2291bb5183e90b9ded9f0dda4cb3d28e182793a95ae54b145"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd1d3d49a56a45b6f73348dbc3dcbcdfe6b67f6f5dd99ab3024b0e8bce3f5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e91a3b0d726c974c310b937a846d68af030a4f4610968581b3d51f8df0d20a63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7adb07c58e1c0671b9f8b058bcf1bada704defdb004208198c012cf894b16001"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe51d1410b98d2ce1f5f0ca81233010afb3d7851424fedacdc747907189644b"
    sha256 cellar: :any_skip_relocation, ventura:       "fafed33b02def77f260aaa271b7e112606471668fecdbff538dc751f2c43e596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d049fff00909fa91e1abbac74e134d3f494944a18f84e888425f61885fcb0f6b"
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
