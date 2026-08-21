class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.25.3.tar.gz"
  sha256 "6da3870d27c2802551cef1bc3af6b6e763a3d01dfe77ded791ba429e0eaad3f6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ab7a415d454fecbe7279c3da473878252ab11ae4dbbd5823165ca79a199d0f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51aa5995825536f1f40062ae761eab337a6ba4630b0ceafe1d6e77e37af360a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f2f4a199f91b78a42223f1d3d08f48123312091cd578d7cd9d97bcd04cfe196"
    sha256 cellar: :any_skip_relocation, sonoma:        "6daba06316d7ba28e0f3e2c23230c559ddcf40021f0d97afd71c0c9d3d57edd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34dba55e6542743d597cba27fb2ce069db184e2579ed0e41d31d21a11ce85c92"
    sha256 cellar: :any,                 x86_64_linux:  "9922282e0ab84b0d8883135316b2528a4b586cd57c3198453b17264c580beeb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
