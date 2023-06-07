require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "8bf2041e8d5c7247e73e7d5b750bc17bd5e6c25e45092aa1434d113dcfdcc58d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f13463637ce049dd170536979f7500c92c01068117f0e85c2b68ae03257f25b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46f83a5dbb478e4c51e9bb0cb42782d081589d981836a0aa143da1208a3e8b7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4994d5c24161ba806ffa3be8b27fdf466e0ac3d6978ff87a55117075545ae44"
    sha256 cellar: :any_skip_relocation, ventura:        "db752393040049a34eda99c10dbdb39e9b0a7df459d3402ee8a5bd8a0ea8db59"
    sha256 cellar: :any_skip_relocation, monterey:       "187cfec5e5a51d9eb84704d447ba467785f2ea7804845c57cd8a47a0c580930d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d11cb54a1f5d6b5499a6e27b8298c34c6b5729488035802e4a4bbd27d533fd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132e0e44bf292fecaf5f7fcf13285192696d1a1fe025be9ccfb5b7e91afad334"
  end

  depends_on "gatsby-cli" => :build
  depends_on "go" => :build
  depends_on "node"

  resource("ui") do
    url "https://github.com/keploy/ui/archive/refs/tags/0.1.0.tar.gz"
    sha256 "d12cdad7fa1c77b8bd755030e9479007e9fcb476fecd0fa6938f076f6633028e"
  end

  def install
    resource("ui").stage do
      ENV["SHARP_IGNORE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "install", "--legacy-peer-deps", *Language::Node.local_npm_install_args
      system "gatsby", "build"
      buildpath.install "./public"
    end
    cp_r "public", "web", remove_destination: true
    system "go", "build", *std_go_args, "./cmd/server"
  end

  test do
    require "pty"

    port = free_port
    env = { "PORT" => port.to_s }
    executable = bin/"keploy"

    output = ""
    PTY.spawn(env, executable) do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("keploy started at port #{port}", output)
  end
end
