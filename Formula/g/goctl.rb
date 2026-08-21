class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.10.2.tar.gz"
  sha256 "ef0247f24122dc9531f72a992b9bd4f92469b16690d131336abb9d4ccd2a832c"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac133e6737c55cc2d810d17e5681a26048d1516e59ad1adf40a2cef017e4b865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110199234560c845a99331ddc5fc6820da167446aab4a285a75138948d22b6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7054384a5dafadca373f0c6d7c87c77acc96d09106c64d006b1261c349aa229"
    sha256 cellar: :any_skip_relocation, sonoma:        "b432c4aae1288217e9b11b9dbf808a714a38c7cb1d1a28012d043f441735a48e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9175d06fbe63cbba873b3e98c8c4fd285c2ff9756e5cc242b1cdf49c0439f28c"
    sha256 cellar: :any,                 x86_64_linux:  "8aa69852a0771b76b0481d5be5b31de30b8c07390e87acd3901e1f8b3644850e"
  end

  depends_on "go" => :build

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
