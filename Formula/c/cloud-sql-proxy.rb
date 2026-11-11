class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "dbbc06dafca12d3d080efb4eb60e13c8405d1282260d235364c78cae705a3cf4"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "099f16643d83ed0f07e962549d2b297fff2323737481c8e48fa71bd3351445a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9017cbb29dcd8378b8202a7b16c4326a31be6ca1368fe7c2aceae85cfe320421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e919a099a87554420ad4f3391dbd6b10c5a1f334e0d1fe4245d8cc4c95a20eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb3bc483e9b0c2cf7cc8385e870705d4b1571d7b13f1945a927efe8d4f37a60a"
    sha256 cellar: :any,                 x86_64_linux:      "a368d2391db504faa012f99c48c4218ed1633d26c26698810a70699c0b97b3a0"
  end

  # TODO: unpin go@1.26 when Go 1.27's ML-DSA ClientHello no longer gets reset by TLS middleboxes
  # ref: https://github.com/golang/go/issues/81199
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
