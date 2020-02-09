class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.22.1.tar.gz"
  sha256 "44b5b4b92862b2c544abc60f5091309ed64f6aef33957572459317acc7bc2aa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "31a1fc203332ce6512244d40cfa8660fe28f803e8c9b2139c3da8ed1fa397892" => :catalina
    sha256 "479a3fdf5ca45736b0e25f1cacba96108d819f76223c53a5db188323c7e20bd6" => :mojave
    sha256 "479a0568abad5b752460fa15ffe10006ef7ea7ddd5b0b8c1c47d29459ee20ca5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
