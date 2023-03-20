class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.5.0.tar.gz"
  sha256 "0ab93f8fb0e0bd4a628fe1b1dd13194847c90b26355616c3a26cb349418a6b1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc5fbfe8662e7b79549a9e6a2ae4b1a89bf8f096796d51e542e495ff4c5d5f44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5fbfe8662e7b79549a9e6a2ae4b1a89bf8f096796d51e542e495ff4c5d5f44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5fbfe8662e7b79549a9e6a2ae4b1a89bf8f096796d51e542e495ff4c5d5f44"
    sha256 cellar: :any_skip_relocation, ventura:        "8693a8adc18e5b705626c84492223193e593bb85d4e084ce24dadae1583fe497"
    sha256 cellar: :any_skip_relocation, monterey:       "8693a8adc18e5b705626c84492223193e593bb85d4e084ce24dadae1583fe497"
    sha256 cellar: :any_skip_relocation, big_sur:        "8693a8adc18e5b705626c84492223193e593bb85d4e084ce24dadae1583fe497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5ad2841170cbb77b846053280b20b852eed7fffa4197dfadd77440392e31e9"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
