class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "77d7f670d2f6386de4967672f0c19f738820decbef5af703c478d66683c405b2"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b5f941ab86ae89b8bad851e493ac76dcc7e382c2f909e149cc2fd9544baa790"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaf0d59c634260a2b4dfa343f8f4f863da78ebf2eb63c93cdcb2783f3866e1fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38da506c3ac20720b6a710eda81dfbcdf747c21c9fe6d15bc2c672ff4e2b3938"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c4153b8d1d260a4e68d75714ce011a4db25c2bcdfcf5ccccca4987eb0143905"
    sha256 cellar: :any_skip_relocation, ventura:        "65e45f70cbf63098ed6b29c63e73fb201e90c0f80bc16eea7c9a0625a32d9c12"
    sha256 cellar: :any_skip_relocation, monterey:       "c8d02e89b3c044551b1320c675e59d4d8c298d14c0aae102db03c63b73d1d264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc5731b78fac09afff61a378f01e55e30695cfcd6a46103b82bb32b3020a092"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
