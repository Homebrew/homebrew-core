class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "ea0e69da591fdf3194c695aebf4188515f2567876fab0df3a834c28783cb8d0c"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4f32c83181fc459b594ef6a58ebf86aa26ae2c00c3cd504da32915b11a642cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f32c83181fc459b594ef6a58ebf86aa26ae2c00c3cd504da32915b11a642cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4f32c83181fc459b594ef6a58ebf86aa26ae2c00c3cd504da32915b11a642cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58c315d9a8a17516f93c223ff6849120f8367c78deb4d64e725535a704c040f"
    sha256 cellar: :any_skip_relocation, ventura:       "f58c315d9a8a17516f93c223ff6849120f8367c78deb4d64e725535a704c040f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d6fa95c36b2866be7fdfd833b83d9a132c47dd94099decc065eef1d17a0adaf"
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
