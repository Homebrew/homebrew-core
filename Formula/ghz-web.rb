class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.105.0.tar.gz"
  sha256 "c2c257dcdf708e742ff80cd5a1b205991c9192cf857cafc90ed4be8ff2097ee1"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3912099f366892a5d15402f70331b0a101dddfbbf14dbc191a8e3439dd1968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "889fb16e9087909d9657ecd3c77d7eae7e3e4cda4c4ea7d07ae75f93a7f19e10"
    sha256 cellar: :any_skip_relocation, monterey:       "72150d0b50fec99f8ad719f5c4e1cd72a407d4f4662e30d576026071778a1436"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47448fd61944713a7856142871d5c12349519b12e47f3f7cdc2046221f2ed3d"
    sha256 cellar: :any_skip_relocation, catalina:       "0f6ba02a65297c33f7a94dde78e58992e9bc8cff24510a4a64469dd75416de2d"
    sha256 cellar: :any_skip_relocation, mojave:         "8abc477e62f5f5c9473c666873123fb5743721913ecbd3b915793ff6313f8f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ff5590f0cefb88c8a13ed03777b3a4e1494f7fe39d363f7133d16c315768670"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
