class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.110.0.tar.gz"
  sha256 "254463fd61b316f709a84b184da5309be1c0a4a442145665da26d9ad98da1351"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8989dcaec5e4a1c4d5a17e6d14693f27b96d67bfd409f1b5f25c226fb9cbc030"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd1fa2d6a2be7b9765c59c4a6650a1aa575e0712f2c0a1e71738aae10e6803c"
    sha256 cellar: :any_skip_relocation, monterey:       "11c01581d11d77084b3ea02df656bc994724645c9e7b70b395c14260064f1868"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c5ff32f794822781abd0fbdadce9ce3b336f24a5421618cca9da2d426b324b8"
    sha256 cellar: :any_skip_relocation, catalina:       "a614374a3a1443497d82dbacb9fb70e40025cc87ce93442af80ff0f7d0293369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "474c84d2d3c2dd2df1c29c49b7b9bfebeccfcaf4d6337912eead650081b2f678"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
