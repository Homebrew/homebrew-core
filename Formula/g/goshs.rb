class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "0b3ca3429b5b0c4ecefe8569c982cc4f2eeca5880d85081136b81cc36338f823"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d81f736d07e22d606584dafc04556d84147e65352e0f31f8baf5513961ea4aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81f736d07e22d606584dafc04556d84147e65352e0f31f8baf5513961ea4aeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81f736d07e22d606584dafc04556d84147e65352e0f31f8baf5513961ea4aeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8291b84c09976ada002a75bba2ea5d227f8faf9ff73550e5b19505c213c0214"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2bf59276b33c84e30e64392c3b9d6286c0df7fa192726b25c6de594ccc53e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506fc493854e9c24f88d35c7db5e613e2e3c0696acd72ff29a3bfe327923ca0e"
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
