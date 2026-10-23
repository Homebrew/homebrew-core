class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "6f313075e5b3877466145ede26ae3a7ac9d4892faf230902298574f9aa80a590"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "020d232799e14420db77bac53544e23d94b711952ae20d9081fa17d7624e3c6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4945593d7ab7b090d30c4c70d6014ee5a90bf5c221d58608a154d12ef3f511be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01ea0483b6aca244d0f91d0cda1c76b52b15832484c8ae560ae68653feecd36f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8ea0b88aed2b685b8c9b9ce289d2ffc90c4a66977f608b5f7d5ce939db0059b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c8c0698330dda0f55620f5a9cc549e5e1f2e6e70651c850427b9f601ea0ae3ee"
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
