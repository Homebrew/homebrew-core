class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.3.tar.gz"
  sha256 "ee08c51fdd5a0a86d2d7b724e751e83e169c4db430dd5c0fd8be8f8f80aca62d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4640083daef020d2a06e9bb28927924cce3a8a6f09c88cd73a6586fff8d5eb74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c84d34f968cce7126d76708673138d20fb688842c701fa718dfdb4eb70c86dfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "881f59f5598004c278b56d679eaa1ef5041a0151b15c7c1ee5ee01a81ce45c8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "18c98e42efd7c41eec0dc2b30110d70027623753e54fb5ce78fbda484db03357"
    sha256 cellar: :any_skip_relocation, ventura:        "0d1dc3d9ddfeffc8d2cabb40fd33db3803e0414f43bf2387ddfffac3b910e6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "cb43b9bcc93e58147eafaeea0185f120039b23d5628c1adb5a5d807310779c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2dad615ed95499e283d760c1f14a857ff57fa720d130aec49035e0fc5e0178"
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
