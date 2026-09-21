class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "ef81c240412a5b77b164ae6570857b7a0f347770031a697764ba5167389842d8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "847fb78804de38d4a692d41942f7c2c8900e26d9e6829ce022c5ee3df64d1946"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fcc2024f6276a66caba51963dc3111c7af42084e0e6b230935c9c9a9e56fcfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fcc2024f6276a66caba51963dc3111c7af42084e0e6b230935c9c9a9e56fcfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0fcc2024f6276a66caba51963dc3111c7af42084e0e6b230935c9c9a9e56fcfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d645760e6cb04d2a85ace8ed56564bac2ac3f91cd275bae4bd58debbc60df421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2db3cef644b5b43f6435cd0d5d591992995708ae0050b114a257a0c68671676d"
  end

  depends_on "go" => :build

  deny_network_access!

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
