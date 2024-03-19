require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0e45207362bc17dd37e2efa8c881c72878525bca79ddfc45e6c242ea97fb12a1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be1248bf4f0a1b0824b8385bf78de390a761bb1c4c576687fd1a83eeef4d2017"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61adb55108c119cbaf60a0679b45a2bff5cce9d02e68e90b5f423fc7d0fe8f43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3307c3128ee1a3d12d3c29d969af5dd27268aef707f3cc99cc69934c6b90156"
    sha256 cellar: :any_skip_relocation, sonoma:         "06b885259fd6fc314d58b133749dbe7e2a9a7d660a304b1a298117d69d35ebc6"
    sha256 cellar: :any_skip_relocation, ventura:        "57cf7126114751fd4b4e2bdf2a12d3820181fe069220a046fd1626a8b934fc02"
    sha256 cellar: :any_skip_relocation, monterey:       "d8e8a354dfac6feedea50008b3b023e061dc4591c43ab7e1dd300913ff409c1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7736b3ff430fa17c7d38311558adb2e3f790c771cb7ad841b56793cc0798eac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0709e89362133925d029532ce2fc6f0854d1e0c6cb2063b30fdfb4789b22ef7"
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
