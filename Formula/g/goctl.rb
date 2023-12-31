class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.1.tar.gz"
  sha256 "76e8cc2c56dc2518d278cc5d30a7f8c187721a8e95c0ca302aa3f7112aa0216f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee15a4c99e1eb1803d2cdef431ed73fd6dfffcdbff134b4a871cc38e0000f114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29b7f4b9f244671648464c85bc2711386533f141ae04cd58f280acd033c7b879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "614392437f50d95bfe015b1c824b6bcca7347cafba4a8b67c06ccc083c24e744"
    sha256 cellar: :any_skip_relocation, sonoma:         "e60226f016a4e35d5fda4fa8a312ccd0d8ea045b93102a7140c8769ed5e60713"
    sha256 cellar: :any_skip_relocation, ventura:        "6b0476e3f4574569edebc343383a606b83091ca6d11857c220d303cf907a6d21"
    sha256 cellar: :any_skip_relocation, monterey:       "aeae96e95d6451f574e64e48ca18af894a6f5b7bd0722d87a0a878910ba27929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea333da5fad9c7e5a78d2e7f04ce25192b19da47d859e6daa247c13f78f0585"
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
