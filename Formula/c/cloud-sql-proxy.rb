class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "27d270aa964e9694b7654ae6b575934705d9105df2928d2f99fae02117b7865b"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1abca7e7a13c44d1aff8d5d80adc9773505f6a1fa320bd3f0be2635bb4bd71bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd6224b0e800c6ce311e5cd0297eee500eb54a3e0abfcf2cb7877180c6159866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e39257e952024cef4ea6f5081bd5741d1614f39f1776fe92541c4e3bdad86f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1489765034c23f274c5efbdec83e9f771a03fff77bb3a9028707b2ea97e6585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d843b73360a545cf7eda100d00009a8d441d73cf8663b9cecfee571d7a3c1e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384e3ba0868fb6a57a521b35a903fab1ef687395bb3ad9674d0510ab17ce5acb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
