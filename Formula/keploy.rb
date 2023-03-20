require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "d1da09ddfd83b1eb35a5c5d84c44af7eb3ab09024d41b20ffd9db189a5cfe77b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b823b44e374873dba2995c9a3d52c1fe9a0ec845f9a6bfd136b8d9c1dd1313d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d644409db3abf95cb9e50499d278b619ffd5ecd5cc57c044e627d6707af48968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8142ffc9378c080f4633ac3bc41b44c01ea21ced55a8e401a86ed2ac34186069"
    sha256 cellar: :any_skip_relocation, ventura:        "d23185d8d1ea8e4723c968deb61eb292a8bf4a726a91028c71102bd855135c95"
    sha256 cellar: :any_skip_relocation, monterey:       "9e8e815e0152973ec4c9c8caad83ef9c5edff33e656016402ca8b7e82305c68a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d906d34e797d2ee458c72592efd11e86ab1d135f26b9aac71a374ed5959b7d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da65d46949eff838fe12772a1b2ef292589acba1ed4e966e5416c383a9a033a"
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
