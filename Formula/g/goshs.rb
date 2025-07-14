class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "61000f308cd48b23aa02d2dd41184824260a8d7d6bf47e6a7f658e4d228ac8d1"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8dbc48ee5ff0bd67f1dcd6907ae1528903fcb01d7ad2d1194240b4e1f2bedce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8dbc48ee5ff0bd67f1dcd6907ae1528903fcb01d7ad2d1194240b4e1f2bedce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8dbc48ee5ff0bd67f1dcd6907ae1528903fcb01d7ad2d1194240b4e1f2bedce"
    sha256 cellar: :any_skip_relocation, sonoma:        "383755cdeaa9811ec6e4aeb85c7bf4df36ced4c9d067c87c045cba1faa6a1efa"
    sha256 cellar: :any_skip_relocation, ventura:       "383755cdeaa9811ec6e4aeb85c7bf4df36ced4c9d067c87c045cba1faa6a1efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737fb1e7393f743aaa27f24748c49f6a3af8f4615a8dabd5238afbdd513ab602"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    server_pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    sleep 2
    output = shell_output("curl -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  end
end
