class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.10.1.tar.gz"
  sha256 "87311cdba53c74c6c03a2d51c87491a2c656beb8187c1ef86cce3430a1faf5eb"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00bd0830ba713d1c41cd33599038a2b8782bdca8d0723d2b79a966918eea0237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e5a15db093c542233b81597bc200a2e83cf218d861abb26e0e8e9cf3a947e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418d31ae6f9a5cc50f23f54a0e4071fe6fd14bdb89730e1891be39ba684c3551"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b7ed382d083c0b08d25edd3177dae2385bff8034d3766748457b8aac2c7e700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150d5d1e2fa5c40cabdab03841fa5158195a2d31e7e2bf6c23e5fa4b396da1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe2a8d27793484b00a9bffd203175a29039dc68bb469412063efbb1600d82bb"
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
