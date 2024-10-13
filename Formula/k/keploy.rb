class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0e45207362bc17dd37e2efa8c881c72878525bca79ddfc45e6c242ea97fb12a1"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bf38c01369e0bc33259535a25a8465091f4d88407b177dea61881513ff8ca142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4c1ff38ce94806a8b119129fd8ac7f42633ecb166f05bfc59e705b254b307cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3a2f6707c899ddbffb692af55995c9a7d816d042f8513711cc3f9f5d3ce8de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cce4d0d5f5ce7848a2b4ab4ffae6bfdb7510183ce91e2c1f857851fbd904a43"
    sha256 cellar: :any_skip_relocation, sonoma:         "a66deb7fab41a27e1d3b67231767829fe30f6777ac4a55fcab0cb3e676329086"
    sha256 cellar: :any_skip_relocation, ventura:        "d74339c64292667bd58c3992c102824c066026db888876be155457c43c61bcd1"
    sha256 cellar: :any_skip_relocation, monterey:       "c63d9cc23e4fd38c07824c0051ce706040460e5fa7c6748a7d489ffd64a16b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461b9cdae239304c196d0429a202b86df40a79e24c2342c240ea20bc7001118f"
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
      system "npm", "install", "--legacy-peer-deps", *std_npm_args(prefix: false)
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
