class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.24.0.tar.gz"
  sha256 "fa61ad9a6ea4b56b14016b74f081469bf7b63a2f56ae84d2bbc153a1d8dac0b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "55998445bf49aaf86766301bd3dda7e966cdb0d5692d1167746968e0eb93d58e" => :big_sur
    sha256 "f87e7522bf5a4d2dfadd33586f362c362373de714f46e08f3417ea228fbbf8ec" => :catalina
    sha256 "9381ff648dcb11aa393221f3051685a32fec1e08e1e820dac5f6b4c9add33015" => :mojave
    sha256 "b1004db501274c309e2c1b61c692f38e438ca1742bb59397ce332059259ce813" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
