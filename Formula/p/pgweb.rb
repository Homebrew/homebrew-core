class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "f2974238977d4f405e37918c1158650d34e67f6cfc1b7cb9d3d88ae5881a6d58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26b6c61352c9385628aac4b3e5228218363c5bc037f7b77dc1bb39385acef1fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f11d0b102e9aa1a078bd91ab1593e705c077e7a9b648991c662de0b94af71c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba3ed5e1cbf303aa6245d24e3afc7303bc222f418800422633f886ab2eba77a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f6d9c5291606f74f88524c0f95e884483758d58eaecfbb5e112a4a93cf08618"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3e1d39cfd02163baad3da1aa4323b393f8dc659f6e7c8082368b0f77ea422e"
    sha256 cellar: :any_skip_relocation, monterey:       "209d52e118ceeafd33b2483944d44e464dc03c0bd6da5fc4888de68a4a02283d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3958018c55f4940b0cd6efd9a059ec96003a345cb2b680cfb37b06f2a23da1dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sosedoff/pgweb/pkg/command.BuildTime=#{time.iso8601}
      -X github.com/sosedoff/pgweb/pkg/command.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:)
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
