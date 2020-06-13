class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.23.0.tar.gz"
  sha256 "0ee0f346d76ff771d4ea7df1c7f02e8177a62243078ea5225e5360a0ce5531e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4ad630f17943663e243439aacbcc22f7d4f69a1a7e13216fd5aa83fae84b154" => :catalina
    sha256 "97bea8d63ad8b1c0bc90004275fa503d03e7cb6cbb619bbeba7aba6a98b3cf26" => :mojave
    sha256 "397463704f1aa119b226ab83e877c23b66b9c88e60d126ddc3a8834770d58e9c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
