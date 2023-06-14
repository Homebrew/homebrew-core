require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "3f3691d1a9c6b78ca3395b60aa3445f62c1fc2abeab6c2cb02952508c00c6fc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31a9f1033cc516bbca1300e93040784786641d81f7c3a34eae8ae8c511ecbbab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d3ebe286769e95676567789d2d188bafb12f0b116a82c35fbf2003190622ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e347cdde332d84ae4cd87ef6850b79dd861155502c11ee5ddb434503080e6bf"
    sha256 cellar: :any_skip_relocation, ventura:        "cec42361779647e32136bd267ed3f711601b0d4fac3c8cb9e8d9260e95f377c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a09a0326e431c8672da014f0a1f2a649228daa2b72a185b1750040cbc112c49c"
    sha256 cellar: :any_skip_relocation, big_sur:        "55db0bed90f088de13d55aede4f616de3a19f57f998f40807c4d73d9805ff4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc325652e271a16da522854d36f6f1e5ab93509d67f067f9e5eff1130a932a2f"
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
