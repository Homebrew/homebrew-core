class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.0.tar.gz"
  sha256 "0d2c7764ce924860c326eb92f58ca0fc48f1e39a9c71315a37187bdd0550517b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "deae249c0ccae92bb2e4c8caa38f248566e0824e423efa7f3ed473ea321937a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d7d5c4131269376248af16da8be3e59398f775e24163d8d8c0efb22b62fc358"
    sha256 cellar: :any_skip_relocation, catalina:      "d8fb826951dfaaf31592c306e34dbd2c60341e49d421ea602e8a4b5a508d48a2"
    sha256 cellar: :any_skip_relocation, mojave:        "5cc9eb6d31e356d637115e9a861cd89d633e10783113f36f0ca357bea67cf250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbc575b3812e430e176bd8d035b1ff276d3232019a0ffd446342d7832c7fa1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
