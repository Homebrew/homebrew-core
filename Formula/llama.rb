class Llama < Formula
  desc "Terminal file manager"
  homepage "https://github.com/antonmedv/llama"
  url "https://github.com/antonmedv/llama/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "fbe387c567d4be018c7b031a87c311d866fb892a306c8d0619e5ce800a466bb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9073910ed891d81f9fd5507b457e7cb9dde3d4fc79967d152b293743d1f90921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9073910ed891d81f9fd5507b457e7cb9dde3d4fc79967d152b293743d1f90921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9073910ed891d81f9fd5507b457e7cb9dde3d4fc79967d152b293743d1f90921"
    sha256 cellar: :any_skip_relocation, monterey:       "306440628604a10d958aa92109831598cbe795536399a33d318805021855706f"
    sha256 cellar: :any_skip_relocation, big_sur:        "306440628604a10d958aa92109831598cbe795536399a33d318805021855706f"
    sha256 cellar: :any_skip_relocation, catalina:       "306440628604a10d958aa92109831598cbe795536399a33d318805021855706f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd362a0613cead61493dcae5ee212c732f4d0fbdd5a19cdbbbbcaa8850b2e7f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"llama") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
