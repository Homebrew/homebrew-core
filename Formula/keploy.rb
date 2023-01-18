class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "49fc2837e4ff0d546d31d52589ffaa93e466e82b5ae891f90b2b89b8916ba612"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86daae2183e84a15564e5b6eb9b04e9dd67c5938bde5ed16a3721d6c6c9b83b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "accddca52de64b4830864234fe334754d0a715b1e38810ea15e6e474e2bacc6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3477ff8f1e952b431a51fe6829cf44019b67cae1cc3e12605a5693010a01ca99"
    sha256 cellar: :any_skip_relocation, ventura:        "af08a45ff710aa0839e26a3e4f4c71ca15987e40f00595b0ed82dec32655f246"
    sha256 cellar: :any_skip_relocation, monterey:       "747e0b8a2ba6a9ebb587d66d649d772250bac96f80e3c1d5583522da2e72db24"
    sha256 cellar: :any_skip_relocation, big_sur:        "5398da0fea0fa30d1e3b4e32d6a19c453a819b97d22e33970e49ebaa5355298a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fb2b17a731b42678bfb6cf09e803085af84ebbc504c280becf4ddf5508c637"
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
