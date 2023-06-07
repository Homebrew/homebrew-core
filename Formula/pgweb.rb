class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.14.0.tar.gz"
  sha256 "801f83449b88ef241a30f69d5c4201adc295f4393182cea195e51281c6df58e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9385a643f5e402050e502c82190c9a64b5126b6fb2859b31dbdf61eab4bb2d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc0bd4d27439f17890e61b87793dbb66455f29498511ca52def2060bc7e77f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3495158f97bf3b9e1224edd830c71b63a95990002a9e4824aa7d95e517289d2d"
    sha256 cellar: :any_skip_relocation, ventura:        "ce21f7629aaaa9b3c4b0590d7c535fc2f6c199ae1a21e6bc039cecbf81f14c55"
    sha256 cellar: :any_skip_relocation, monterey:       "3a56da97e3e5d8472203e017b42dbdb561fe7f8874f1c0e6bdb465c142001842"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d9473c3331e63605f7882d4413dd49d9369d8c9cfaa7242c058696ab50ed8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "864cf338d712fde9bf3ab13aae1421401861a60aaef53b295e273707e4ce6949"
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
