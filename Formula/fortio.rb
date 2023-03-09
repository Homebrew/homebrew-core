class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.53.1",
      revision: "fecd9f32c789b1f4e576bef76ea01623ce82e644"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168e66935d5201fad391d4268515e3cff5c9b5c831d671715bbc60bca0d1ea39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "625d6d1f4e20095bb6bd78952165addec0f1b28adbf4009bbb71028bcb3444ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa9ccf76c2e7f9add4a5be90b2f89cd77d223f0a5b8cc132d61815eea339882c"
    sha256 cellar: :any_skip_relocation, ventura:        "5dd60097e8494dfdec00fcd95d58750c3d17e7fcd1088b450024257da6be94ba"
    sha256 cellar: :any_skip_relocation, monterey:       "20d38ac569b33e48cc7d815d4f31e6f970d5ae0291e4a21de2df64cc7ab12e10"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce54410f05c9ffbaffd3bda5e84d404fe9548daece7326590c01ae0c7f285abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db6c6858075055bc1bc26c5009b79ed44d03c55bf882978d0617e90a4613e3a"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
