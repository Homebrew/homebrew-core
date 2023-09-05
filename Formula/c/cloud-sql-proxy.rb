class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/v2.6.1.tar.gz"
  sha256 "b5c4fd1decb2d4091f0ae118e2df8387cbee7ea166047be12c4183fbeecf0c46"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d23b8b8ee145421f570998498500e1ab1bd7add2512a44bc52659445c598e05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867afe144e884f8d75d6969508e044ba1a0596b859f7a1301c2694ab67144512"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd1f47b604b0421bf4552d071c4951485dc0493ffc3746b47765818a2818c90a"
    sha256 cellar: :any_skip_relocation, ventura:        "abac4212b3097d7c0d750dc98de4bf8dd569bf519cf8e653870fd8e1f9389889"
    sha256 cellar: :any_skip_relocation, monterey:       "35971a874eb9b9c1daac93c2839a8bab4e05acc82b8fb506ccebac7cc5600f09"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d32852876e6434659f91aa603b4cc24a510e38c7b80788165fb892a07e95227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c7df8ad9e89374d3cafe761f2bbe5ccad8cfaba0d53241a3b2a6efad12d6c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
