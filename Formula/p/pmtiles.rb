class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "85fd1fd55165c894f027ed75d7ce81c3fe01abeaa7af6c9532b71bb1ba0f4849"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3646a309a731255e686ed83160cfc9fde559e10af7f6d7716a7a9ef56431890"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "778766d05d317d0772d9e6971b330ce07247ed9963743df032405e8243168e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddf77f54eb06bf5e33dfbc1fa48188666495459ffe3c455bfab45318cde6ba2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "83aa5cdf1803f4d7f54abad3b052b23f01ab6c877375d8e24bbc92e863fb828d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6fa4145309f04d128e987425a549be6fe690e698bb98cb31112e742c091717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17b0ec8cc919d7ed634fa0bc53adca06637d9706b21fcf0790e2fa3628324c0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    pid = spawn bin/"pmtiles", "serve", ".", "--port", port.to_s
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
