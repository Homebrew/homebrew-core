class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.11.tar.gz"
  sha256 "4d8c64db7ec463a9366d404cbaf12215db855a5bdbf09253494d79dedd92db98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac959c59a21786dd20a6ea036f44ee40da7c3fa1ab73ae21aa1f544241947daf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40e6e5cb7feda53342820becfc49eeb7ae1a60232a2a10a1e70d9888ec7702a2"
    sha256 cellar: :any_skip_relocation, monterey:       "264a47da7f6c0bf2d6840f5330bf3c165814c5a0de20b532c56c9f4f3e5472c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb450b8dd4d43d8d5bf7d89d290518acdc7e5d2fac618014ac75c6a4fcdceec4"
    sha256 cellar: :any_skip_relocation, catalina:       "4ca29fcdcc1d452f75d0382056367ead92063c5631f238a860d96f507bf133aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7f70d589c08e5245e25ea2741a833354aa562a0ce45090596e952a70d51d55"
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
