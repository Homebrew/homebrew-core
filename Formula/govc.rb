class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.4.tar.gz"
  sha256 "4dd6c06c828eb4b850445bd1a7086e727b4b5003f199613b1d5fbe02e6899628"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df4001eca35945f645316857f30f8abec66977967d4a32ebf93a4f165f6b1d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c91b4629e4d69256c4e5e465f4f42a33ed8a494d75afc1d4dcdb5d30b39cdc87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6490cd024056ceed1a643a36a8b45ce57af920dfce3691223e0ff8852ef5851"
    sha256 cellar: :any_skip_relocation, ventura:        "320a26eebe76873f48ac5636b7e15800d5160e8ea5caabf2a9439f2d38a5aa88"
    sha256 cellar: :any_skip_relocation, monterey:       "4d7e5cb97b4159f901efa5fedb788611c99cf4c5e9f9678bdfa1e01eabdfef82"
    sha256 cellar: :any_skip_relocation, big_sur:        "878cafc26326a4b86690f683f4e76d02a795a55860696c48f3a137bd40b2b4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9325ccfc9594ed9a58e102f177ff6a8cade0538cfc88145b2c28db1665a5a352"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
