class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "312d8d5a50ec920734c3ba6721f2088c9c9bd3d010091f867300dfb4803dcb1c"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "843ce6317e986244adf32a2ab77d4a5c403bdce0095df44b216864e94546e6d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c25bfa91a745076c5526e081af383b7f46862305cc8b15c37972aff2ce6b37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06da29b359de2cccd630f9b297f887b34ba69688f7a8d136d5948cb78d8aad46"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dd94ae7b9ab70e60747ab384f6950b865f982decbc1ef7033138e05264afae3"
    sha256 cellar: :any_skip_relocation, ventura:        "054f4fa0d92a5a96f02390193656b50a257eb9b1321bf646d7fe7da1d4ccfe4f"
    sha256 cellar: :any_skip_relocation, monterey:       "1dbdeed731f14f5bc2ee60ad2beaa2c6bf1b380d5b3991bf82aaebab80d494a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "880bde96c0821d8051625a0760aec9d72b259b7b70276e6572e6b60d54c30d62"
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
