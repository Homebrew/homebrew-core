class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.5.tar.gz"
  sha256 "642ec3d091f48542e2f9537a9d51c355bb230fe26f113a3aeaac39e0ec5d93a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9cc385a8d32e24ca325a9ca0a7cef1dd377db32eed84fbf91179aeff8a6b8cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4fd62b1f42c311351cf1f64f85048c9c9a2dd98be47329df0fcbdfb54849eee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d58b26b7af603a8e926ad860bf78349d8c8164192053689c1b28c164c7185ce"
    sha256 cellar: :any_skip_relocation, ventura:        "65c0b3fd10cbb4082eaedd3292907c23d2039bb40c72d8fe46960fe0797596ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2767a3241e4b65dc0bed247df39ef357659288bd5447a44d7e61ca20019a0482"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ad87f48f11a77a2b326103c6612b0dba901565362ddd820c7b77e947afee63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44debd77c63e6cf201c592f9323349e15f3564c8387d25eb6a9039870aa048d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
