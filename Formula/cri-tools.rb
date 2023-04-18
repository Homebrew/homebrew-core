class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.27.0.tar.gz"
  sha256 "bebe1d17217ae6480a9ce8371dd266a96d6289426d5d64a3c3b6f11d6a8d535e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8265880cb3555b4c09c4a01f4c5a7726d1c70261e7c82658d4bd3dea8aaead84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad700959efa8e4f76f5e51475ee328318bf3efddcb3f6ca189e146a079357a7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c514f64fb78a7e386aa1384ce6a5bc89853d51b8668906f3efa1aadf43f39e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "a0e91737f76bf162d084ac9006f6684307af77d5804eebe67f54d529692ae66b"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a9c3730b5ecf9eb59d59a0fbb60a8497c9c148a8fafb7b932ade5830fca0f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "75531f29e8d0f29def374157871ed04dd86de26d63b4b4e30cff0b29e4fbc6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543a8d867994dfc5988e67c75ee132bf34832334ec17a98b4f9f6a62d38cdc62"
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
    error = "transport: Error while dialing dial unix /var/run/nonexistent.sock: connect: no such file or directory"
    assert_match error, crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
