class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.3.8.tar.gz"
  sha256 "6be791980842091056286e9bc98c183b7f3ed5e55d612e58204c818dba0f9449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2804d96b6e9e78a11a4cd381b66c10f29fdeb2eff17b4c96ed038478e91344a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c0c137fdf2ea2befeadf794b73a4e95c04b0eecc1b555cb234f273172f2fc9d"
    sha256 cellar: :any_skip_relocation, monterey:       "d75ff2947324e3ad06393230f3d23f81beb7a9697d414ab3d88c083316f4d85f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f184f54a63d4619f0d8ed0cd9dc703b4e7bf9363aa44e7d1bcc4a322b74f4202"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f88627242441bf9733b753aaf075273fa7ad9d2d5fd7e9000d9be1ed2dcbf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3ad74cd0aa5e9176d5880111ae929d06ba74d58a833418f638a25f34459d24"
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
