class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "370452533d2a835469dafd3286aa8f32572395b67f856a73d736b2ba0b447707"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa53eee013b991b28dc9ac2b3ab7b9efbbcfe676dd3ebcb6fb6cc5434c3c52b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0ebf9bbd2dbb99124382863b77f965796e2fd10d05af5b95b4cccea992824f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7b16459e2f20001d02fea33aed771e4a50f03881bd6855eba379c6460ce5418"
    sha256 cellar: :any_skip_relocation, ventura:        "46a531c61c1bf0a24c4ce8bdd882411196c4d8cec3ef96d3c6a9d19add6d067b"
    sha256 cellar: :any_skip_relocation, monterey:       "2d65b43d6739ba7f89f0609e7f5268f37f9b78f2c3af85b759fe374f41b6dcfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f36512526e60de7b2489e14eb17cebe880a8aa3b5fe27a2c7f877607b35b028c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "052699379fd641a0cd6d42af5200c0f8ed61ba432cbc55d3336f323ef22616e6"
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
      sleep 1
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
