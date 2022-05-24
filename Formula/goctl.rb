class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.3.5.tar.gz"
  sha256 "cbb131ba03fd26e4871ce9543cf8aa64fa1547d6db5c10390f512e72d095a722"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79e2f1247f50c86b9e3fd7c3b81e9bd45aaad9a83569246cca6fdf47ce4c793"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e46436eb825f6619aad4a6f369e9f1c18a4e9fd9f102c0b8c0d298c4c18669cc"
    sha256 cellar: :any_skip_relocation, monterey:       "a908fe2c8c2d678fdd18e1006b1ca40ab9aa18cc80de9c4d3d268464eeedad5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "24e7b7d9429ac1ffce9fb8995aede76bf331423acb8fc91914ebd4672d363a9c"
    sha256 cellar: :any_skip_relocation, catalina:       "3276e19c220ee783a6c27953508d267724452ae0b4e0e1b0101075febc64942c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcff876dc282749527083ac1f39cd37584d64165558ebef83ca4475a8964c610"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
