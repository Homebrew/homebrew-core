class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "0edaa2bd4a6d44fc0406e1b4f45421e17b2ff7d49b2d76e57aba15eef25580bd"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "081c6255d0a264ebcc8e7a866b5df76b0d60af736284db53c60098b7451f064f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "081c6255d0a264ebcc8e7a866b5df76b0d60af736284db53c60098b7451f064f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "081c6255d0a264ebcc8e7a866b5df76b0d60af736284db53c60098b7451f064f"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c1383942263cc214bd212545267ca9054ddd6808f94e4d8d407c3115ce6e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d2c23cc4b59dda6b7f6e4f267d86adff7dcf5faa21e9368650e6ef5dbb8b0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "779e6eac1bebe02029a5acfd586423d8a7b58428dc836780714d1bb3c6bd6a45"
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
