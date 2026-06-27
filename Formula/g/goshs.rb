class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "5cc4db479ae26195651b625c686b2fa23cc1b9e611ca083f9f1964e5c6154eca"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2deb8cc37a433668ccc48f998ffa0d70f0cc57ab6034724bcafb99c777d3f1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2deb8cc37a433668ccc48f998ffa0d70f0cc57ab6034724bcafb99c777d3f1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2deb8cc37a433668ccc48f998ffa0d70f0cc57ab6034724bcafb99c777d3f1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "887cdebb540ddb0abe74864a13058c6a8a0b47f6bbaaedd1db136c9fa767326e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75ce11b5366777a2aeb9c6466843d21de9385e6db475d6f3197e518e886a85a"
    sha256 cellar: :any,                 x86_64_linux:  "6e94dd8eaae71adad4f159d3189e354915ea20c180d1b038d18104086a85d057"
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
