class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.28.1.tar.gz"
  sha256 "c3bfb10030df2b4cad909e26aa4a1f003dd1d0a829e7001de57d3e3074822cb6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    manifest_sha256 "5d6e87d1abbf334231a4123328bfc51f117d6b1fead50b1b01b52817480de1f1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "846b36c3e2ecbca4bf981f8bfe6299b5705f32cea7e1de3721fc54d87a21e089"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8b692dee9b88f43096fa199e92daf2227b2376a8a5ff4c6edc785226203629e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d94536a47429a1d32c26b1d0ad51767ba3e080ee411fc71a788298c1f58adc1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8492f9215b3da7e59b2a9f9f977e0a96411d565d6bf35ef411db4e1c81d665d"
    sha256 cellar: :any,                 x86_64_linux:      "f12101509516f1e39d7ec2534c36c367948d6a3230b45b206034364c73074210"
  end

  depends_on "go" => :build

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
