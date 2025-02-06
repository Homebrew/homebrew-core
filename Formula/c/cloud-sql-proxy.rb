class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "9d4d24c5e513ddef79fa0ffefa4e6a16478e8e638c560975c2ddc35dd34524dd"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4030daf174cd141a365c304468402db1190e36fec4e28a05eb8d2102d3ada2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4030daf174cd141a365c304468402db1190e36fec4e28a05eb8d2102d3ada2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a4030daf174cd141a365c304468402db1190e36fec4e28a05eb8d2102d3ada2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce0655850233742274d6087d6d2b5bd9e75ef2b1a4bdaa646aa009b20a559bea"
    sha256 cellar: :any_skip_relocation, ventura:       "ce0655850233742274d6087d6d2b5bd9e75ef2b1a4bdaa646aa009b20a559bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82a720bd54521c51958d216bf99efb96e676994e84cc3fa985badd2ef4614816"
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
