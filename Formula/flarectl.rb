class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.34.0.tar.gz"
  sha256 "4ec0a0f1d27086a5c62fcb4ae8c4d914ae2904ef71e8269aaf0ebd35b498988a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee001a458b70b61316c55516c2e848d6dc1382e56c1cf948d10eb2892bd3a152"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec09feef0ab8bb2e365e0038ea1d7fe6fd407012322a21f579c7a26c0dfc4716"
    sha256 cellar: :any_skip_relocation, monterey:       "cd394c046e9589b37cebe0786a3dba0496a4fa5a8e0c99523a527bb2510da9ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef24d6df4e8ec5a8d98383a360beba6619bddff6c02e599bb03f85ee853a9400"
    sha256 cellar: :any_skip_relocation, catalina:       "c255a91a54cd870f574f4e9baa45945565260374eb60e6570282a653436f9796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e480d30106d9847a518a4f90478755a7d33fca58bf1aa43207399a49caeb923e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
