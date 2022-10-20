class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.1.tar.gz"
  sha256 "019cbb71d900903656282e448fca8ffa45b6288a3f50e7295b5a4cd68ab0a3f0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5897a2d65225f58a75b1070820df1700dddb05dda30e33ea66d66f6cdaa076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1036e048cc2b30798349e22bc5314c1d0c21dd37dfa5b3ec344357100b964eaa"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b8dfa9a4aea0ed66e0543d7d26245cb6101058fff23d550fd3e31b47146ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "42cbe4c3b03c547f5b1ad6316834de5823c6858e3c644e892bbbe66322b494c4"
    sha256 cellar: :any_skip_relocation, catalina:       "dbbfa50de696dc23766f33faeb32774dd91422179bb8e351a53705742f8f7521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e5aaa27bb51a94fb47d31a6c93e89ebea68be1d7b8960f2b25c740afbbbb50"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
