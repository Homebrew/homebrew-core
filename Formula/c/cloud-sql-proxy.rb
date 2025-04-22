class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "b62221f9eef118503785080ad120e4b958efa22fa698fa7e9fe80d0d14e757e4"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef8f44445b6859898f58fa84750aa96c7acc0a0a3fe3bc9549b80f45d1ec36f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef8f44445b6859898f58fa84750aa96c7acc0a0a3fe3bc9549b80f45d1ec36f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ef8f44445b6859898f58fa84750aa96c7acc0a0a3fe3bc9549b80f45d1ec36f"
    sha256 cellar: :any_skip_relocation, sonoma:        "30be20fb79e41bc7f5ef8714644b14ddff818344703e79a28e5016b5e71fe834"
    sha256 cellar: :any_skip_relocation, ventura:       "30be20fb79e41bc7f5ef8714644b14ddff818344703e79a28e5016b5e71fe834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6dd8590195a802f2dd24439d606b3d1d9590781876dca70d44b24a6bfe7cb8"
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
