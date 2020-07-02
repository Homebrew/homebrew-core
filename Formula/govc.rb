class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.23.1.tar.gz"
  sha256 "792f295975f86e86ebe43c5de520267295a8a4346440d89fc36624370d4264af"

  bottle do
    cellar :any_skip_relocation
    sha256 "0619f67c0287b822ed10ed641519084f814b979841f5c5b2803fe4f179574d22" => :catalina
    sha256 "bb5b9c0c3ac7b74db7783e0e4ce409f49d6d484df3624fb6bfa874860bbdc01b" => :mojave
    sha256 "ba609f775f5bb406024cd3f0c73419ea2b73601116c221738a3f125116dadb1f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
