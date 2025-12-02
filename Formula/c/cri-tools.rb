class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "1ee70b05e10afd5549878b6239e008799db5cee070ed686dd3286684a88fd0d4"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0959ec5b12690f6aa20c53645ad595f554ce6d4b092f3a5d8922942c84f7f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee7ddd1b9eb269e3e60520c8abaa0aa19f97eb4689a20e6201d2c9b3a2f0c51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee7ddd1b9eb269e3e60520c8abaa0aa19f97eb4689a20e6201d2c9b3a2f0c51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ee7ddd1b9eb269e3e60520c8abaa0aa19f97eb4689a20e6201d2c9b3a2f0c51"
    sha256 cellar: :any_skip_relocation, sonoma:        "16789ad6c1b650496e6b505c63744108560e233fe8636fb9f6165b8a26510e62"
    sha256 cellar: :any_skip_relocation, ventura:       "16789ad6c1b650496e6b505c63744108560e233fe8636fb9f6165b8a26510e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "197e68cd972782f026480369c8ac3cd41ef6a19e0ad588428c73078c4fb0f700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa73189113a9e83b3bed5b286aef529f27f41f7beacbe92636e28b226e7b8d0"
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
