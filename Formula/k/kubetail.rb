class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.14.1.tar.gz"
  sha256 "644a6008a46c7ab837da7a70c89f913914d9fe578f9d5eb9307acabfa8548107"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31a2054946cd822a3d42a57337e397630324ee8079fa16727e5cf71862c9264c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37896625e7508e4729d1762c563cac477052d90b38986d60b982ff500c6e17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7753273bc336b5707e39fe4c0b89db9b4d04ed2de177a4bfc49500211affa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bd6e56f3774beb583cc95c1d0cbf8d4d1e284b9c0bf23f282f41a241b5d1d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d7f072b1494a2adf04a63d4e75dbe8ed27aede45194a7d8621b9bc42f89b951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf2266681326ec54199769cb3b4523b218405792acbc78c18f0e2fee9e6db30"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
