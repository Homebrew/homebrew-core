class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.18.2.tar.gz"
  sha256 "07e3162f58acffc25fb7bb880936a4901272180198480859ad4930a21c0c840d"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13cb2c4d37cb9478caef03ffa20c816a45aa6447397ea610e139f25f15898f4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c567676f6474906fe4ea9a44db7fd48e0fc8438b1654f92825b1f586a4e1f4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3abe6bf9e5025b89ae8adf5faa66619c0e5941a1637ecb565ab52ccc20aa199d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73f2d2b0541170a6fa965bd40208a1f571a52a1ce8a81d20b091679e103db7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "58f0c9372500b09da1ed66f657fe84f1c80de7c74629d3b09dbf83dee33d67d7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    system "pnpm", "with", "current", "--dir", "dashboard-ui", "fetch", "--ignore-scripts"
    cd "modules" do
      system "go", "mod", "download"
    end
  end

  def install
    inreplace "Makefile", "pnpm install && pnpm build",
                           "pnpm --offline with current install --frozen-lockfile && pnpm with current build"
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
