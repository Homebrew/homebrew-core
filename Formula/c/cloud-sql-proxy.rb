class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "fa5fdf41557c50f865802785449f35e0e168edfc25aef3b4f6b0ea455f42221d"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "268aea1a65dbaa9d8c3d5b2948c64cbe052e6ff8d50b678cba680ac59ed1bd2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187faafdb45d90400b81b196de9deb5bd52ca8e707abd1187e07855e2e493620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eef16e72ef63bf811af796cd7b3d83f5d15d442e3aa588dd8f471108a15678a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb48e1f5edd2edceb8151b9ffa191944e66138a80721dc73f1c4b9bf3ca6ee8d"
    sha256 cellar: :any_skip_relocation, ventura:        "d76fecf30e347383032dfd276ee0e7617a2d49efe34676369fa59ef02ad3cba5"
    sha256 cellar: :any_skip_relocation, monterey:       "364e1a88387bf67694cb26dbf46849692f47b84058ce9668ceaa2c9356c2dd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2733bc2f32cac2dd44209c2845da99112fb7810140658872d216fd4679dd2cb8"
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
