class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.5.3.tar.gz"
  sha256 "50611a3acf261642d7b422428b5c72b935c408d13a9be82030a3703a0d730567"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5bbec41132cd5a3ebd27769835f3e04ebf34cd75ada991dbda1f2448552cad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5bbec41132cd5a3ebd27769835f3e04ebf34cd75ada991dbda1f2448552cad4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5bbec41132cd5a3ebd27769835f3e04ebf34cd75ada991dbda1f2448552cad4"
    sha256 cellar: :any_skip_relocation, ventura:        "c9d1f9cb2b0956a2933782584edd1e61914db636021d5a762f421a2252fcb732"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d1f9cb2b0956a2933782584edd1e61914db636021d5a762f421a2252fcb732"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9d1f9cb2b0956a2933782584edd1e61914db636021d5a762f421a2252fcb732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78d79c723977926ffb3a13cb9189011ec68a0c2a2961b72c99d10937440185d"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
