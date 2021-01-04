class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.7.tar.gz"
  sha256 "4d8dca19dae441381a61033437c8b93c205188ede2cbc847c6cf89e54c69d6da"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fb5f3992995885604593c9de36aaf5805c95444736591bd0c0ede7f2d7639a4" => :big_sur
    sha256 "bc341c6a8d40b7f0b71612decc945a793aff97d70efbc32d290943d5f8d127f9" => :arm64_big_sur
    sha256 "4d0a4d3bb0a33b393a44b992ea0e595d7898da141c0ac1cff578c465fbb80dec" => :catalina
    sha256 "a675fcfb7def5e459c4b83b288a4f8fc23984e81cafeefa5d209b6e0ba29fdf6" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i", 1)
  end
end
