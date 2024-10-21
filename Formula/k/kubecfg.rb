class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "dc9e4c5c9d60573f61639adc2d600feee5a756b98b3077b0751794aa404bd11f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d895346500b71b15c8e317cb25c17ee3710db8761bc08f6526e68b00e8da0aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a76f4692980817132fc276373248d49e897e53adcf2cd363112ebcd37c9e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dd94166fcb789b1d4a39e06ded793676c9a5600febf085ee93e3d038d98dd14"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb6ff31bd7a8be4a515776a33a5db7e3687a5fde956efc098f093fb52c0e4067"
    sha256 cellar: :any_skip_relocation, ventura:       "6535d6e0c5bbdf1ab8cf02248711bf6c73034e5521a05142d96086cd2347eb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6a1760e21d86e682c4304b9f42e6652e0b6609807c94257571471cf07736f4"
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
