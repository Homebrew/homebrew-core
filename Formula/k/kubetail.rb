class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.8.2.tar.gz"
  sha256 "447ba0e51fdd91c9a43c7e6b720f2af961f27d1ae791fc7ca6e8b039544c911c"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baa6fc21521bf6edbc9dec7b4212acfdf82607abe1b17f192d94d048f7ac7250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d61c5337f6a0dbaf0d9e7ce5ecea6d63c18464ca0e9b35192401f295332ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a61a2ec4aaed3ad1628c432266b3d8a0901d2c6408dc684899baedf774c57ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "4760dcbf6737d83fe6162ed0eb05f273fe5b265c16c4e1f3979e018c95bca602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f87faed8f6be6d47dab7ce5092cca065fb198e6f545555c05bc24424848ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a4a0c623133425df23b335c0e5ba5cb7bc0267ba2e99bd770c75757d0ed10b8"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
