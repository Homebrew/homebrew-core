class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "648ecb3bb0fa23aa9e9209576fe5b34a8f7245f659861b542d2c3a471c8b172e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a3b0d3d2f8b1b7b2adc29d2a51314246c49bcdc63d70b7bf370acc8bb2b9a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a3b0d3d2f8b1b7b2adc29d2a51314246c49bcdc63d70b7bf370acc8bb2b9a77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a3b0d3d2f8b1b7b2adc29d2a51314246c49bcdc63d70b7bf370acc8bb2b9a77"
    sha256 cellar: :any_skip_relocation, sonoma:         "702a814db0c144f3379a2022dffc23bda1122bbec655c3796a3f9727f34cb654"
    sha256 cellar: :any_skip_relocation, ventura:        "702a814db0c144f3379a2022dffc23bda1122bbec655c3796a3f9727f34cb654"
    sha256 cellar: :any_skip_relocation, monterey:       "702a814db0c144f3379a2022dffc23bda1122bbec655c3796a3f9727f34cb654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaec70ff206adfe02276866411aa71b1c5fb126761cd0cc3fbc3f8424f988c3c"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    generate_completions_from_executable(bin/"crictl", "completion", base_name: "crictl")
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
