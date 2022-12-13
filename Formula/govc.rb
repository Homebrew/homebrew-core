class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.0.tar.gz"
  sha256 "78c26fa3958ebf2dbf919b36ffe5b82bc02071bb3a060bc806a44d91f9a65426"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008d992c3051584bf6c41095997c01a015447931f05f26bfec737fe7240ad978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9957781456f042e13183f10c15592cf18be29b3b7e429d5bf6a93478b517141a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3205e16957f1a1b3a019550677d8531fc3875b68339b15c7892d7d4c7526366b"
    sha256 cellar: :any_skip_relocation, ventura:        "90e1a831e83d07dc782c1d11b3208c6943526e1739d44ec46c88e546c43823dd"
    sha256 cellar: :any_skip_relocation, monterey:       "39ac20022024122d20aa0336caa2f75a60107e547c8c45215a0c1da1c09caa98"
    sha256 cellar: :any_skip_relocation, big_sur:        "31bdfaac215c256960b0665dbaeb81ce898e41d5ddfd381439d39a45a2164cb9"
    sha256 cellar: :any_skip_relocation, catalina:       "fe23c3a9bb07e9abbf172aed5e3b1a6d0b6cf7c46504ad6c5946aef2a816036e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aba7f2a11bd35be3a0a3c64cf6a68941be599f2ad1ecc127298308f29514ea5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
