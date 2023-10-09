class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.34.1.tar.gz"
  sha256 "56821d2b1d34363be964c5aba0f452fb98fafa7bcd4ea1ed95b4758ed23664f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f32204a7481c71c9cf79461a3effd8494ae8cfb215efb931f9062d80d645bbe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e0b6c705d86d40b7292702b50f6b740109262d2ace579c92b90c4f3c6b0a66a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b33e7c4cefbb9361b018093397ff7476f012ab839926159f37ec7c8ef6911b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eaed1d3e790e7dc9f367525602e903d4a337a9f2db7424585219725f1810694"
    sha256 cellar: :any_skip_relocation, ventura:        "63dd46f73a8fb8bf1791632166afd134522f170a528d4f53ef68393900668a16"
    sha256 cellar: :any_skip_relocation, monterey:       "f44204adce3d5b2e3795b9e1c3983ccda18fb6a51cc7bfe0a4f30ebb7d371825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf71a279f116b9aa6e7eac46269c5c6942f110a28b1633ce514d828bf09d105a"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
