class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.5.1.tar.gz"
  sha256 "326946339797fdf82214da724ead6d3faa21482322b979eee37fe98dc7db6da8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120b561a2a4e69fd598de7ecfa45bfe1373bb6848ac0fa11fc216df5dc8c91d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120b561a2a4e69fd598de7ecfa45bfe1373bb6848ac0fa11fc216df5dc8c91d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "120b561a2a4e69fd598de7ecfa45bfe1373bb6848ac0fa11fc216df5dc8c91d9"
    sha256 cellar: :any_skip_relocation, ventura:        "e5527a5a6e57c434b9178552d409b1807a2646b47275617bacf00067bbf2e854"
    sha256 cellar: :any_skip_relocation, monterey:       "e5527a5a6e57c434b9178552d409b1807a2646b47275617bacf00067bbf2e854"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5527a5a6e57c434b9178552d409b1807a2646b47275617bacf00067bbf2e854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e3360b9456b9d3ee9793531d4768751c0e1717ebb4de1f1f56e79b77a8ad2b0"
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
