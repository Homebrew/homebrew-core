class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.0.tar.gz"
  sha256 "f462ea2e6ab3e66d83dd59fab22066798693c972b2ef82b6c27ed5c630746d13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "857f404077d506c5b4d5990922b41bc0cfc7718b8287b595b1bc924d98e2a438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c98d6adfca4c09420d89118daec394bbb4118212af48ea1446e6ad78ea6e8cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc7e4a80a145951c7c65d7ecb1ebfc1e8170e78cf3b9d935d796e469376d450"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f65fcf6dfd6e7696f3d6ed95ef60a5fae0651c3e22ea1f36a8cefc28d826afa"
    sha256 cellar: :any_skip_relocation, catalina:       "594856cc03aad57fa131bc23adf2a86eda76131b328eb8f79da959d52d3c1cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5287dde2c4d6d69b7cf1bbdf5b08efdd8cf145e745c8caabf12dcb019c04b67"
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
