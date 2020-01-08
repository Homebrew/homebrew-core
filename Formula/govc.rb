class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.21.0.tar.gz"
  sha256 "3690bc16e6193ee0d142e8abc1941ad38f841494dd460277722ba3873e0793dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e074718e72510da869e1de0e0765b2b4b53f62e4476f83ac08be9ac4deb6280" => :catalina
    sha256 "5a15ab51411921620747ad949f689754db9199376c4be2f50a74f8827e602f39" => :mojave
    sha256 "380c582a43e9f75915dae9591eecc82144fb9418d1e52ed9cd079572db70f082" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
