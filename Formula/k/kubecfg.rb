class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.33.0.tar.gz"
  sha256 "60b8419dc853ef9b61b46c8c1d400e0a715dc5519aaab8ebb304a8e4c0f04fdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afb20badd2a1fe23fd6336943d78d8efa1f116542dc0139d9fc02bd77ed11e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298ccf9880c20a1292e0417960154600b3d767525f73bd5f27dac0ff85fbbe0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42803811de8c45fc4414df6f7f457bcf0050cce2253e4991e58a2a8ba50b0fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "42299d639da83470ab897ba661fc2a1f3ae6d7bd3ab673886219d346b6aac6dc"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e43f651fe7beb49385bbcdf06745f01c4c818a4efb06de44675a5b8de10170"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bd74ec1c204690abb91cb08f6c860abf8115f1f08234ceea2fd61d4dd61d312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcb019b1ae42493d9ce05ecaf393ac8b9f4659c8c5ad7163c0266179423623f"
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
