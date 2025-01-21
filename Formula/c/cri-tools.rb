class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "2d48319be933df77c660fbfe7efef8c3d61bbde6787e2f33725bcc519858b287"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b68927510eade50bfadd828b034f4537b890ace8cb0e23e780ecef795108eea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b68927510eade50bfadd828b034f4537b890ace8cb0e23e780ecef795108eea5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b68927510eade50bfadd828b034f4537b890ace8cb0e23e780ecef795108eea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa41eef8bbde177b4d6ea9579442882f1e1442345efef797ccb79c9465d44c77"
    sha256 cellar: :any_skip_relocation, ventura:       "aa41eef8bbde177b4d6ea9579442882f1e1442345efef797ccb79c9465d44c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ce3accc44490a4e3cbc38e6a657a90c04520a7339f9e83d69d4126230731812"
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
