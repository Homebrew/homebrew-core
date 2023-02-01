class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "acaf26011a421a1074f644bc10eff18f04e232d41420d69413d8c303aee18adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05bf76601f5d0a6a436365ea237e69745ab106b83de8dff96dd9e663875d2b7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e1db1ef5b454acfcd315a03d62309d1afa05267f756ea010344fb8ad2b0884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3ecca0f18958632813e9b038b08328169b51ea54890604f31069bc37e079f42"
    sha256 cellar: :any_skip_relocation, ventura:        "f661b9077d23984403cb43c45e28f56f22afb07d602395583ef3739ab7bf5b0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b98e59200b119bba55573ac30d74dec758f54b6ddaba96bf95aeb40f56701e2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f331331d7483a1b977a884412ea35205afb7fa77470c3c6eec2c5e5505e0b0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eb32f5dcfd0b5faf8a4d82b2c3c044b426c4357decf3bec6ad0c875273f8054"
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
