require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "83527b6b41af39c2390771e5349a1c1aa986af4ec9845774ed04f46fb7a61935"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b13d53953a6e0c7d63bb59c90c06354ac75021ec1ccfc861d2efef698921bb41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17408406f14bc6f8cd507d13e0bf9689e1cb276c19485c1ef2d4f96caa6e1e02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2513bbec97c88eed6fc51fa5c4465cda971d5c57f4350653ee89842d0dce39b0"
    sha256 cellar: :any_skip_relocation, ventura:        "1e86af419519903df94f575b2401e0013125f5acc62dd16061e4ed32571b67b8"
    sha256 cellar: :any_skip_relocation, monterey:       "0bb21d5ea6c78b37be009e6026a9152c1b650877e1716b6654a3499f8bab9a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "a26eccdc0055e018bacf1243c5405c78e0d6135713a3d34f318ec675fb771a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664a6c6cf78b9ab58aa38ba4201738a2d9c60cc0a21b44b8bdeb0e589822e442"
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
