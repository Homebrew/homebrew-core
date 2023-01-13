class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "753c3c44a8fd5f66234906d40b484cfe84228674acad93d5baf6d2499dd8f415"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3443b8b744962439aa42673d3771285fb3622be0b976594302adb8f7c9e2ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aa012cc29a3a36a8d83dac27d70ca55a4081f1cead2ad8eac82db26478e73ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b0872fc61efc10d75f16704682eb540cbad1f5cfc8253f686e0e6e18543b9a9"
    sha256 cellar: :any_skip_relocation, ventura:        "1e7245bdcd1852f5ad6a0aafa53fe13062140fa633e9df280efaefab840be113"
    sha256 cellar: :any_skip_relocation, monterey:       "c28cd9bd0d74edd2d365b58864d24eeeb6ab5ba645c1dd9894b48d076330aa19"
    sha256 cellar: :any_skip_relocation, big_sur:        "435cb55d95a8e6f8bc6d6c1b1327fd230553fc6cfab28ae9bdff9d6ffe4c103e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "072aa1d44f01a48714567496c839fc116c8491e2853f1a91fa842270c5a57688"
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
