class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.1.tar.gz"
  sha256 "8b5f0748b6bbbd1088950769bb82c44431478a9e80f729ab791fff9862d89a09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d25c773efb73ea01f4c9b1dedaa4581fbae63f9b16299134f6ad97225a0b8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6a5e9b3a2c9ea651a0b27a717ab459745b2a4694c9662cbd516e7716b70576f"
    sha256 cellar: :any_skip_relocation, monterey:       "0044cd2837de043928b2e3860c5ac76cc1f79c9c6b7f6dfe748e6dbb92afd290"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca9122def6ce7b60f470ff8dccb6f9df0bee40e924d79691715ab796d6ffedee"
    sha256 cellar: :any_skip_relocation, catalina:       "a7e040bab3cc29e23eab63e23ff1e4dfdf99dc4bbdbbfd75652bfcf3fdbfd840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4381ea4c4678fb2fbced93802bb9820993872fc741bcf10955e5aa9233824b7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
