class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.13.1.tar.gz"
  sha256 "5b2343c96d5e095f1596bba22e97e695e39eed0dccac1ff21f993e7b6b34d380"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e14632a17b58a2727db24dcf966a2d1fac8d34539ab68368fb1047b03690b678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f0ffcc4f496cff79ce61a5cbd802b9473e0879dddec451e8a47e5647a30a1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "877ea2745d70cba5f92f49161c3710e3c7a195261081aa0cd0d055e922fee3d9"
    sha256 cellar: :any_skip_relocation, ventura:        "7f9c4b89f73de02a6a28086a9812bd2265ff03ccd032b7ab4955af3f3275a5f2"
    sha256 cellar: :any_skip_relocation, monterey:       "fb15f15241a76edd0a9c818861c0a47f104e99274c248cce08ad2fb3606908b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "012864c1af54f525cccc5a5750d99717e2e9dd66b7e31a9debfe6080cffce83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262ca14c95b9345ed80719bc6d06ab6650fefa57ff8ab74118fbab9c304db258"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sosedoff/pgweb/pkg/command.BuildTime=#{time.iso8601}
      -X github.com/sosedoff/pgweb/pkg/command.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
