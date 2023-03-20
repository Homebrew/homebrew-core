class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.29.1.tar.gz"
  sha256 "4adf945ae1119f40466158508e3de708731b97aae371945dbf391e8e7dd51da3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd22315c4e4a4388ff505833a18d064134a305929900f8ee9ae68335382c6adc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96837a4df36fa2e45ec6e68f65e78cc9b4e9c15aaede9cf7fc4690df72c2e017"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa090af8b71eea8e57702a371065505a5f1661ddc2305e74079b97471f9d641a"
    sha256 cellar: :any_skip_relocation, ventura:        "fd615eb793a5ef9a406204f24ea65f89d3a8a137af4a7e3e1e2bcd75479c8a04"
    sha256 cellar: :any_skip_relocation, monterey:       "61364172563443f092d3fd6350e1229d6628882a027b8132cb5de22eeb64b8bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2706579912d9b2fdeb3eac77179b95303989f263b97ffd90cd40ff765ff35131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc70ab9c84dbb2c411d01873e87f8f3219aae6fb9b4db7948ea781ba34ae579"
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
