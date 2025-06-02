class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "d8ea9e4d34d63b589b894902ed9f6300a5f08dcab113194e74990d3ca3b35787"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf4dd85cde657b9c8b741beb23040f5d72b1854108bac81cc0589b7eaf3fac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf4dd85cde657b9c8b741beb23040f5d72b1854108bac81cc0589b7eaf3fac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cf4dd85cde657b9c8b741beb23040f5d72b1854108bac81cc0589b7eaf3fac0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59d50515260afe491e2411389db1b09c2bfce6d69c01e400f4a2010c0da594e"
    sha256 cellar: :any_skip_relocation, ventura:       "b59d50515260afe491e2411389db1b09c2bfce6d69c01e400f4a2010c0da594e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edb81fec6116582918247d3b04a11f093af99a25e6202fb088a259b970a9213"
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
