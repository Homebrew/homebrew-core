class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.3.8.tar.gz"
  sha256 "6be791980842091056286e9bc98c183b7f3ed5e55d612e58204c818dba0f9449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4cca10122b2d8dea66573cbd475a478beefdd65a1962db34f4dbfb75352fa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3986991fcbeaa7e05c911429423172ea0bd484575f04bf14224e12a110d23fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "8d50eed8c412d2980842b9ea323654734217845b85bc1a02c908ac27ca671b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "05649429ad1bcb16bfba7db35d27e106c135416352bd53589ebe8f5e52dc1e84"
    sha256 cellar: :any_skip_relocation, catalina:       "83f964355d440fcab9c35550fd3abea999b0b6b73a347250061fbc750c5b5b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e2cdf1f76cd71414375384261084b517e27aaeb18c0254d1a41191ae553c5b"
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
