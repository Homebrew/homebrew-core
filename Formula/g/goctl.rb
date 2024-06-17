class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.5.tar.gz"
  sha256 "c30e9a08acc35971a725b6b63a1adac321c988c31f197f7e74e90d0a6a2a4363"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac7aff5033d6ef6af3001f77802f15edc7c6bd078bc385edc58129579097dd6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b8a95d04b29eebb4614f660a3eab20b59b6b66847f335a485e93a0b15073004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089fdd5f2180ab6b538849ab8192602c15e661aa9aae2f44af62a27bb1ba96e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae9e796b4ceaed22d81cdc84fc92f9c014c15fbabde64e82024552ae10d63c33"
    sha256 cellar: :any_skip_relocation, ventura:        "02f9ceed15aca3da7fc0569310e53c711cf5ca55721e062715621aeefd56a3ad"
    sha256 cellar: :any_skip_relocation, monterey:       "9b57f688d8b9922a64158dc181b9b27c41f0578c3db98e63f170a64c60a56855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4945da2e8933f655a6a61f0637eae2a991197465851f2a8676da8873c1ac5a"
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
