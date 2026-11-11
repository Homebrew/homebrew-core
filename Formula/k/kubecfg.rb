class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "b71f195e575d46488f90042ebcd8ff947465a121b41265523393dd2c344b415e"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6807de461c5584f42fd39f626ff2f227b846075dbb168f555bb0c16340f8edcf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b54c552f270c20abacc5bd26d57233c8976d849be8e319ec84ec0570a6694aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "864d9f54534ff84b052e6b7f406c1eff11e680e37163307d6e8f11eb9aa965d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f63ff3030fbbf028389ea03efaa055e94d05f1ff13549c399c6fd95f6d2c4f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fdd1977ddb42062290044c6524f86392e23771da94144b8ae9ad54ef903daae8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
