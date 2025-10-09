class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.9.1.tar.gz"
  sha256 "fbe8de6ec73518a266e929dacff9ab0870879c08908f3de4c0f4e290bc1db957"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1b3d0ff0b904b0f4efcbe9ddb851af2f0a2d6dfd77fadf1108cb080314d26c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf15159d2386000f916a4dcb8a238b451f0ac63a9e8810cbe5b76f9c7a52816e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c742eb0280e24107ac0d9bc7b731391f7f7b46e7bd8f5d70385b04b1308a6c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1aefce07d72ffbbe774e3fd94ae212ade0ed2d01f9d1b49e6dbac985ddd593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59677856ef94ab569e49e392d8f01d68c421f0de9616d292fdc4798d450fd4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ddee414dd5eed709490400dfbea801f1590eccde379fe34ee09b6d2e9972581"
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
    assert_path_exists testpath/"api/main.tpl", "goctl install fail"
  end
end
