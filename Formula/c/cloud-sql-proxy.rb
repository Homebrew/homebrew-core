class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "312d8d5a50ec920734c3ba6721f2088c9c9bd3d010091f867300dfb4803dcb1c"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64824e8c1e50c2a4fe6a25fbac86507b91df87a520263934b5f8de2ae8080c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32488ea3f173887df8ad2e6cde990451d2add0e87939f05638d02bb3e22481f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "396f5a8e460126e314e9d5fec84810742337916f2e8f916eb538922cdd4328bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "992175decbdd9418242f4fd24d4c2288212a73721508d95c2f7e771a294ba2da"
    sha256 cellar: :any_skip_relocation, ventura:        "7adff3a54978fd483d82ab1b8645e5c8e981cf0baa7e467f472ec6ebee9ad3d9"
    sha256 cellar: :any_skip_relocation, monterey:       "121bf36eb439cbe2c50a7058cf6f1a0536f57b267e53bbeb810f19a8b00dab93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6111a0a31d6be3cf8abbf436133efc40e2d85920eb1229778f603db835c97452"
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
