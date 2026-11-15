class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "b71f195e575d46488f90042ebcd8ff947465a121b41265523393dd2c344b415e"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "617145ca626af6bfbea695192dba5d84b39cd57de8899af119a5a2ee523209dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77c8441a2601f511a927c3af21e36bea92ae40ada39af42dc8a4e1f521ec1100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82206c027cb9fd10662443b66bb241da43dec501384d07f2a690e4bd06c202a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fdc06fd07d3eb54ea5125f2fd837786d734c9d3fa9c71acb000264e586cf58a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b6437c02c751907b7a1f4618d57cde779a3d841167e65223435015ffb16c9930"
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
