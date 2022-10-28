class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.53.0.tar.gz"
  sha256 "c659f89a59afb46e0f37f27cd9edf9c905a34f1f72eb45c086f6d1ef293b492f"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3e94331914449e2976c17035288cc144b1586b641ee514d1f1d600be83054e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e5eca69f74452235b13f1adb266b8df48ae0097bed81658a40fddd349cf9764"
    sha256 cellar: :any_skip_relocation, monterey:       "e2b908c7df5bf2bd38effeb4586b985f5aef8d638b82668db2be05a51ff158a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad594f4b8d84be5e69966d1f8fe4dbc03acd05d0f068ccb8542d14f2fc19b512"
    sha256 cellar: :any_skip_relocation, catalina:       "1ac2d2bb21704f808fc77fc797c68cf75770f59575f2a7e6a1447fb6f7be8af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689f2ae74392438959829a906694b1b58af51528f638f29dc493a68a2ad23f56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
