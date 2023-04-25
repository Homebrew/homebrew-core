class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.29.2.tar.gz"
  sha256 "6eda1f8ee15f8677c87759921e24f0ad16367fa5e44c84158196915a8e655fe9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e46c4ce561998c4c0a4b290abe2610f6a20fc26c6aaea3f5f80034d266086800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "066c4c3d030779f16da0b0bcdee90459aadbfb2a1f635f10ed36a63ef6da4b45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e7f3bf6743bc66076202a0342397bf90393bceac40b186d640e483cab08631f"
    sha256 cellar: :any_skip_relocation, ventura:        "52b9d70426b7442e696576ea3faa0f6e7ddf1971e0ed7f9b79c5f06a8c3842f8"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea73a4a837da216665f4ae643ab4a974f3a6f70dc00f3a4e40bd9e7f8220d66"
    sha256 cellar: :any_skip_relocation, big_sur:        "40b4f5b9911f90f500165d49bf0290a62669b6461adf6b71a066e7b9e7cdf322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ca4c6abb8ff4560763d7d981d3d3703a15141865057b06dcff85fb7b0cfc9e"
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
