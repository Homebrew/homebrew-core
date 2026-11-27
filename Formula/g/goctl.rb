class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.11.0.tar.gz"
  sha256 "feb2fc99a1a3d7c79fffb6277ae3f0db9c4f3a4d64b60b1175ced46dee85d215"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    manifest_sha256 "e107c0f12b31f08dd64db9d029591f19de225a6ad79882efc15d4a3a442154b9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30b815a0f05963c7813d0df72bf92f4940a48096160f2af4f854db70bbfde108"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47c5587b97bc94cc6310d67f0991c268b3fdb44eed6d55093867f2f7a51ae32e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bee67440bbf36e46481e028a338bafdd04e239d4686049102b794068adcab5ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffe6ac7df754566c89186dab5adc6554ff9aaea6b6a9d4d9e9dc23d1b161444a"
    sha256 cellar: :any,                 x86_64_linux:      "6b2b981b8e457d2328effa7d102ab89c3b75196282718c51e0afb5409a47f565"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "tools/goctl"
  end

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args, "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", shell_parameter_format: :cobra)
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
