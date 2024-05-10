class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.4.tar.gz"
  sha256 "7cd3f6b7368efcefeae20e103dcac15b99bea1171bb22ea405c8859d0c98b762"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7360c157ec7e00cd9480f9f98106087ca8377d6075c959b888a81606b003c1fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd7123298589a6f858d164e281294dd533ff8264a483c8d214e620c870fb44c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe9686bb5968f01d74703daffce0e339f01e95c815e87cdb6e5c5ca47d7051b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fa5a18c6ebad2ab62b4d4bc25b03c3593e8021b7f42653e16d7623cc3012120"
    sha256 cellar: :any_skip_relocation, ventura:        "e1193da79db82d380b30ed7fa78308d8fa0adf054d707566189e7a48ea6c3b0b"
    sha256 cellar: :any_skip_relocation, monterey:       "e7a9fa8f0c867c70634b48423438bc0873acdbf3980e2d1de30dbfa12461559c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608168c9f53bafb839517b45dcad39dcf4492e31ec9bc339066d00e72bd4b28c"
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
