class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "31267ed218c1e4f780d67122ccaa84424e2d5d37cdc37fcde4008ed165743a8b"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fb0ff2f585983c8f3203b21431b4ff37032c68157ff36a91f82f6895ded55f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a34d07387d2ac606e2cd06e83a12e71e6514126db3cb47ea0bcb98e1e14558c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "365978ec4bbcb71f742734b378e2fe21ac196ba56f595a1fb69bd1112af27053"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a84bb7032095d82062c69ab5ab188416e8bf7036fc997154b0ce5e8715ed4c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ef58c7a3b6b8320d11456fd113fbf38adc3805129ccc56160074a9a9ac638a3"
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
