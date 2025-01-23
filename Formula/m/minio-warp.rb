class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "38227c37d1f5618c10e03dfbae8a460983da2678de363674b418155e5278b105"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c09cd2c409ce619d91b03e5cb1a77f2af67ac92d420c1c97dd6fe90be09aa37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbabb1553fee56501262164cc3d5afe1dbc9e407f170e9da5c55f94e3746bd34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9e26a27a81b95185a98b5a73bad22346c879b5ba16b135879431974f00bcf2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0bf9cb2bbfd40519620285cd3a18548e4e4a959ab46dbba1c1d0621a872c640"
    sha256 cellar: :any_skip_relocation, ventura:       "5300787a6659beab98a696d97531c32b9986f94697b9f6147e99108bec67a3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1e716599788a9765cb7c3afb46978ddba259f1b1918a433755d7b5c23a5dd2"
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
    assert_match "warp: Preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
