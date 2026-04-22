class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.10.1.tar.gz"
  sha256 "b8889573a26b24306dccc4d7e991e0321780e19ad4d247f814a4f65e11f07c69"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "559dc79f895ef231894d6ad061ffded217c784eda9598e497756b3427e756cfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb712c36fad7e43668ce9f367dbc9d517e1f7bca07df0a1b5afe074997916dbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b12bd097a7940f2606023d2631b4b60a7e92d3b2f8025fc4646a3e5f9fe808b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0976ece45058588058d5f00d0b8007c999f7e8cba9605f696916e13c0476a8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa77776ac70c099fff460ccc6d99f5dc1f2a294bd31df0948cf6897c45672dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a69a66e3f9081d4cb410e11d55f89f24f193957ad26afc6b8a0321fd4f26847"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
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
