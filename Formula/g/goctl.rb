class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.10.0.tar.gz"
  sha256 "4fcd6d56ce24272000f83eebe1bc7552b7931eb619a56bb60cabde6a187654ab"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d0a54388204a1a1898057013472bbb98e9a7711efb59b065eae04e46e89fcb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e56349df82031d85d4bf1b973869c32acf17773ee710ca859622688f928404f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2374b42c10623f2569d8132c8ff9d1fd8ee111f48b683e7e9f5a65528a0e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a7fee4a17cca516c4bfb99b8fa49b39409cc8dd7432981609437a6d2325d817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16aded581e1b30880288323b382fafa62ae33393cb293ea8c8db5fac0d3c4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb64661962c91187198992f41a2da12a6e5d2f10986d3a0a40c8686a8e4ff2d"
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
