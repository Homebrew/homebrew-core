class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.3.tar.gz"
  sha256 "3f40f82b325910b713b8a325a7483f55211e9ddebe6996422a3c38cf5eeb80a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47543b482ff4281b43202f0a1d5754ac3276f5a5a1b233a9d0dcc3d7f28109c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f38328d831e0cb21f7045f74c15f01c989f32a2f2eb228ea8793b43a73bafb92"
    sha256 cellar: :any_skip_relocation, monterey:       "9db2ba1693a0e615014822eae84b0fb16f69177d9e06453874f4f43703482d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d71430af5c3a67c6290bf0f068722bc2a44d6aeae3c588f90a13889e5e24832"
    sha256 cellar: :any_skip_relocation, catalina:       "ca9e0079a82b482e17f28b46a9545c2b1333899be89257df2e47296e71a9fbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f81e5db11a9319a27714230fdc9e7fdee6c6583a8ecccce4be24898e027054"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
