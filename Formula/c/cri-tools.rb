class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "2d71ca416a4657646d54725345f993fc1b66c8023da02952bd0e63fd515f49e3"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008934d075ccd36341e98414e5bf5d42988d4e2e0e7a73f4dc242aff4bd4a51d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "008934d075ccd36341e98414e5bf5d42988d4e2e0e7a73f4dc242aff4bd4a51d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "008934d075ccd36341e98414e5bf5d42988d4e2e0e7a73f4dc242aff4bd4a51d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21321f265b02859092aa0678ed0c633991a5ebc5462cabfd2207a872b409602"
    sha256 cellar: :any_skip_relocation, ventura:       "f21321f265b02859092aa0678ed0c633991a5ebc5462cabfd2207a872b409602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f66d7e6cb312b27388c8cf93cae4f02136d4731b013a019f85e82153063f66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf3c77059a9da11c6adc99068249b0acb444bf9fdf163e43110bb26e7fca0ac"
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
