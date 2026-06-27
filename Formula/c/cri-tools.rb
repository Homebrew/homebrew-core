class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "e0433207c55e08ab9e42e2fa3b3df3769ebae7695c145b600d79878be599e08f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07212f7e5f0e132febab40183ec0b424d196a6dc1b9050685e2e985d8c110592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07212f7e5f0e132febab40183ec0b424d196a6dc1b9050685e2e985d8c110592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07212f7e5f0e132febab40183ec0b424d196a6dc1b9050685e2e985d8c110592"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ccbaab4a765edcd24a6975db057ce018adbc022daccd7e2262d6e371afbbc9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7924ad7948a0ae8fdded3048b15f171355aa11deb20cb8aa09a00cd55dfd8f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66dc2365a581595fe3c238d001b57388c7a7dc18de50a3b8ba5355f2b9006eb"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    generate_completions_from_executable(bin/"crictl", "completion")
  end

  test do
    crictl_output = shell_output(
      "#{bin}/crictl --runtime-endpoint unix:///var/run/nonexistent.sock --timeout 10ms info 2>&1", 1
    )
    error = "transport: Error while dialing: dial unix /var/run/nonexistent.sock: connect: no such file or directory"
    assert_match error, crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
