class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7a347919cd1adcccbee79021e8deea9283570a0006034cfdacab5bf2e1f2f3fe"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47a89fb0fd79e84bb147c4e2055171e4a7d428226a35d24216b322b564f55b78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5642745653fafbb283ffb1112a6dbf0f6b19b049e588d0ad75daf764ed84eee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6816de896be4be895afc098d8b60e7e0551f268f20b9dc858d6399c510396d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cf43dc0aff8a43b1e8504b82d25bf6a6ffbf6eb1061a518d1f7f27025edd789"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe654767e1f8301f04ceead701c0a4f84996412f5669bfdd8e7ab44aee981271"
    sha256 cellar: :any_skip_relocation, ventura:       "c5b973d6938d2f01d0edb2018a7ca2cc4a2a5e59d6a3a6fb6772a32fbd174a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6873a14cc571d2c20bb2b85a80e7dab3df2825a1b1237631cdd3ef3c72e9aeba"
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
