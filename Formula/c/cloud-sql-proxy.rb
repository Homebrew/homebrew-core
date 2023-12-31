class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "1886cf74f7a4f31bd4d5c7865f0fd5ca166060a0436fbae21e73cabd840b5401"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41d0dcdee07bd06bada3ec90a979c8fa8b1e54bd3e6c681a1b0d9ee1574b1dfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10a134ab552f5617325d103e63548f89cc55b9879d79e881fc9ab80fa0957da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e054de540bbe7cbbea87c07d702d593afda5c2a7b776ea85fae24ac1d34313d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4a9846b3026e6b6c1ecc7c21ac86b2a33b8230a83a0436bd72e17cb825fd5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "63139b2d51821a6877a289941c5b4859860554225f9fd80078e1eef60d65560b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f34d2c6f8b6ce9e1c79f26ebcd737cc09d195e79d18c05f9291fd4edec33ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5bca1d01109c6f21eee5a9b8ddf60965237cc44fe5d17dd8d75b574b454ac7"
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
