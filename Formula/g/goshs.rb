class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "57645c607200cd762e018c27e091ea7a845a479bd356a602bad90498ebf0fe2a"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0323cfbe2a560633dee91cd61a34084eed4ac1e7accf63520635c6883006c3c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0323cfbe2a560633dee91cd61a34084eed4ac1e7accf63520635c6883006c3c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0323cfbe2a560633dee91cd61a34084eed4ac1e7accf63520635c6883006c3c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7edc15d132d48216aeb14b98359bb4df605c69948e3811f55706742a6efe6fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a70308b86b7943bbb77e04feba0a5e523d2d876ab80b93e98abb9cb5e8688e40"
    sha256 cellar: :any,                 x86_64_linux:  "232287edf4b28a3a83b877924218c4ed7912e12ab56028d06a319b6d3e5b316c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
