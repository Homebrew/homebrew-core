class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "7426eb37f6b5e773c1c256c30d76b797c61ee4ba7fd9bd7781f5e3b464af3fdd"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e059faf072b05f6bbb06c6789bc8a8850650d605f7871910a8dec36d284457d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e059faf072b05f6bbb06c6789bc8a8850650d605f7871910a8dec36d284457d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e059faf072b05f6bbb06c6789bc8a8850650d605f7871910a8dec36d284457d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4eff59fbc1638015b1e9323279e9c93756a11b1b17bffc1be5bb15412adfa827"
    sha256 cellar: :any,                 x86_64_linux:      "d343f51fbb93feee209cd311b6f7f793316df87f375865db9ecf9a361cca6333"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
