class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.14.3.tar.gz"
  sha256 "367540bf7d4c57d788af4c73d96fbee158d954fae30d7f1ec5a28c321341a2e2"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3626b38bf9f29ec23a7ead381201c83733683b7f1ed940e7dc69a53d37717910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3626b38bf9f29ec23a7ead381201c83733683b7f1ed940e7dc69a53d37717910"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3626b38bf9f29ec23a7ead381201c83733683b7f1ed940e7dc69a53d37717910"
    sha256 cellar: :any_skip_relocation, sonoma:        "46d5845cbe31ceda40cf055c83faee0f8df0309fc664249949a74d84829064d0"
    sha256 cellar: :any_skip_relocation, ventura:       "46d5845cbe31ceda40cf055c83faee0f8df0309fc664249949a74d84829064d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae368af2b5875600477332bbc8813a77e7f987fac5adc3f6612709a277d84f21"
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
