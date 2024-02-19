class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "1290ae8cf5d35e8ad6b7bb1cd46f3cf39e89f4e0eb09aa3979efcb1cbaefcb2c"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90725c044496832439592689f70d2207dc7196ae9ba1b134c7f58fb75fa22b8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca634a66c66297d8199dce02f73c3eadc2880b3c76dc9bfc87965b8eb54e8117"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "358d69df96121d516bbd7ba22e0abdf3e3c152de159281ca95d7e3adbdf5ea63"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfbfd7609367f22fec4f86c2093ad1130d11a4c1f92ea68c4eebff700f81ed55"
    sha256 cellar: :any_skip_relocation, ventura:        "71927d1425fa416ccb6fc52af0c235a6310b56698793fb213a0c00eaa9c67df9"
    sha256 cellar: :any_skip_relocation, monterey:       "bb51aacef60a24ea4b848f9055f302f0649284219ef13911cea85bd2390b5b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b850fef02b69657ba06e0d5cfdfa4f58063bbe88379edbd26f97f88d59719026"
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
