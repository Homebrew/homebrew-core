class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.7.7.tar.gz"
  sha256 "6bd4f06a7170c86bcf9d1afcd46250ce8d5e5ed629bf8e9ee9a7c299ffbb68b0"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd528fbec2987dfe0384bd171e5bc32bd4efb785ee57491cf14d898c3a84eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd528fbec2987dfe0384bd171e5bc32bd4efb785ee57491cf14d898c3a84eec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cd528fbec2987dfe0384bd171e5bc32bd4efb785ee57491cf14d898c3a84eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "197af2fddbd9088b9ddaef8e9a862cb8fb6aa8666026a0a50022e7b9dabdda87"
    sha256 cellar: :any_skip_relocation, ventura:       "197af2fddbd9088b9ddaef8e9a862cb8fb6aa8666026a0a50022e7b9dabdda87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6619bbc538401203a780d4694be262b4e541479cc0fcff949fcdce80546ed17a"
  end

  depends_on "go" => :build

  # version patch pr, https://github.com/zeromicro/go-zero/pull/4645
  patch do
    url "https://github.com/zeromicro/go-zero/commit/05eb6e846e746941ccafc852ac3a242d02e33a42.patch?full_index=1"
    sha256 "5b2d87638e11cf3b53685c2b62ab31fdcd9135136b73752dad64059f7e7f89a3"
  end

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
    assert_path_exists testpath/"api/main.tpl", "goctl install fail"
  end
end
