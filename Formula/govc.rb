class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.1.tar.gz"
  sha256 "123e70733840fd851914dda3372b6d21db8e196846654d5a675b8297234da8f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9abfebdb20fb2eef0d643d6f66e54512a3496bfc80e67478c713b1766a9f2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117b7350ba6ae4d73c6589c7d92d69436d8cb1287cfa2b907ade7d99611df489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "892fbb7ca99902978fa1cfeebf44639a283ff6dc95b272598fcb685f8f74b15b"
    sha256 cellar: :any_skip_relocation, ventura:        "b0bef4b21525bdd5fc662617921aae2c817f94a7315dc62e1bdfcbdbb3d08dce"
    sha256 cellar: :any_skip_relocation, monterey:       "c79808fc579e078a3c673afe694e87c328c529a457105b47765736b7de65e1e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc9f96616e275cf2c7d3d89d011a253bf24ddb82d25ce5955d2addf713bd77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f433964ce725ee3b16fcf474fa253bf02810e37caacf7ffec1f46a740ac29efa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
