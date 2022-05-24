class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.11.tar.gz"
  sha256 "4d8c64db7ec463a9366d404cbaf12215db855a5bdbf09253494d79dedd92db98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab4d7f6ef6f033ba9e255ba5ba1192f2f835e6a430d03dc553872011d516d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4de10cd67782077f391a212cecc978605813488eaf1f09d66a339aaf99f1b6c7"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef3651c6bca97057478b218a913d4d83c53825283e82f20a40138ee278de3c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "65bbbca6901f6bf3ae3022250e2f138ad9dbc386476503641eaac9bbac4585c1"
    sha256 cellar: :any_skip_relocation, catalina:       "a30327b12de71ad523c7efdc94e53b1f7b855879c8396499f7d095d84a39a946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f7e79fae8d7692422706790b129dd609c4b93d5bcf7e6d67343e19e53fba034"
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
