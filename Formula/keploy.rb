class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "bf7a0ae8e56810af4434371365c9581c0276e66fbf9d9b67ca6618d82d87b505"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8342a6f024feaac36c022834a82dc89352e5feedccb0879d3cfd86cb3aa7dbfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97f8d0e2a5f15649edc98470caba30e4000d642c7fbb0369d24c55cf21f4a389"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70207a693a5f28779005faae4aeecb3ee642d5e956000d72797eb1daad2fff90"
    sha256 cellar: :any_skip_relocation, ventura:        "6ba6e358a3856b43de7454fc961e620262197de487982a4c35bbaf2418916eef"
    sha256 cellar: :any_skip_relocation, monterey:       "37c7a018b73ed85314739957ca9a4c5721676863df9861d82c7026370618ef4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0498768fdd6d4d256bc9a270ed8df6fa85a580f398a2f782416e7a964f301800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ac048a74f8c8c02ec67a8194f9ba945882ce2aaf0b0fced499be08f95083ac"
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
