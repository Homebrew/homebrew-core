class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.29.1.tar.gz"
  sha256 "4adf945ae1119f40466158508e3de708731b97aae371945dbf391e8e7dd51da3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fc4debf9076285ed2c2a44333fa79dafe9f3d0bfb7f48ad85144a2e1fae9d60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b53840aa304852e3f9244655682faff57b99a616c2b11809c52b01f82dc4a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df39c8e5518380d22d61124d57ac18c2b7148a947395bd3494e21b2ed3d216f4"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a7e718ef59e42dc001cf7c5000fc8a1f465cdd342371aaea35d828bc639a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "c20c7d59acc357c3719d32d06a41a12fc0f98f724883cf214c2d17baa3f38ebf"
    sha256 cellar: :any_skip_relocation, big_sur:        "adf14d50c5d133d25b630575f153d2c0e65c6504e85965ca127f7ecdecadd91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e24ffd6e1ae560f2efc69b55b78dd66527d8b646a7dca7b30cb271f3f7b26f"
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
