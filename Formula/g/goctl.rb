class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "293eb698f47ce3b87253536731c65185320f2b1a91bcc60fa56efbb7a70bcd2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8a17c9d909eb26fcfe593cd5da2fe5b584b50f6eaf971a8bb9f7488ad9a723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8a17c9d909eb26fcfe593cd5da2fe5b584b50f6eaf971a8bb9f7488ad9a723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff8a17c9d909eb26fcfe593cd5da2fe5b584b50f6eaf971a8bb9f7488ad9a723"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd30d0f3f779dc5dde44e54df59081ead5815adb512d440c95093d67966a0fd"
    sha256 cellar: :any_skip_relocation, monterey:       "3cd30d0f3f779dc5dde44e54df59081ead5815adb512d440c95093d67966a0fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cd30d0f3f779dc5dde44e54df59081ead5815adb512d440c95093d67966a0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e467733f8b35943b10fcf40dccf5865dc178aa7c3c74cd5eaf44b3a36684c63"
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
