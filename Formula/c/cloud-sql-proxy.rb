class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.21.2.tar.gz"
  sha256 "aec9cdf34a67051bd5c644de7044dd73b5c519ee8b87578717ba3de47c5122ae"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22267840659ea92799e75ddc3b33365b3949f1f155e0fcf8a7ef8c688413a289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa31498b042ac235aa33d95721a78ab94940164e188a95b67e55ab167e379f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f84e9c6cbf9217b4663c38d2c15be324d3148c4d014f427b5fb112ef502dd95"
    sha256 cellar: :any_skip_relocation, sonoma:        "3756ec89094b922ba8ac2461068071fce521149eccf4dca9a2e5ac0c6644269f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "508e6a3ab21116cc9997aa9c7ae9a6f5f724d78639f51bbd7a7dc983cc1843c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57267a439e6ba81b514a56761436baf0512fc066de2fd7f6288b7bca3d6d45e8"
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
