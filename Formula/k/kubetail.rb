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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25187ff81db2da1d545feab444664489d3e98072b32bf191c439a8be9f42f3ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c93fd5df629623d06d5e3e44e96255c3ca71fa273eaa0aefe36f9ccdf4ff29ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68ae75dd11eb7ee2a05e78ba058194c1988968f6d72a3749220812db5b38a186"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "accb79774284004c74b0d1e011a3620c14275a25fc97a2e242968f511c30252c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6c31464b278c966713fb4fd8a4445c91dbd422153dfe8f6fe7e3cdc10f494ebd"
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
