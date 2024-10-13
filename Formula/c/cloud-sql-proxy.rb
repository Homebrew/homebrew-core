class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "bed0e7cd3d04a4b23826a486c57d74ed43fefb07fec73512e8bc9d634be020c8"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e37825842f5e4bda9b77a931e8673b189ec96680d23105de9d7caaaa7f7d9b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a395c2bda560d64c786a3b10bf720bfe783a1f21478a84e9b3e31108cdadde2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a395c2bda560d64c786a3b10bf720bfe783a1f21478a84e9b3e31108cdadde2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a395c2bda560d64c786a3b10bf720bfe783a1f21478a84e9b3e31108cdadde2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c5a5b30d18af5b1031ab104847f045336db52083fd3b0bb1ef16b336635c89f"
    sha256 cellar: :any_skip_relocation, ventura:        "9c5a5b30d18af5b1031ab104847f045336db52083fd3b0bb1ef16b336635c89f"
    sha256 cellar: :any_skip_relocation, monterey:       "9c5a5b30d18af5b1031ab104847f045336db52083fd3b0bb1ef16b336635c89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6015d4c6720a3dd7b27a6175941c72af4e0c0b89a359c864088ae34fc95c9bef"
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
