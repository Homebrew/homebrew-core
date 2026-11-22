class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "cab6c9014601b475bb81b88181e427d471236c705eaff44e4709281ada59bd70"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "f2d7cf1cd3c819ecf5b975d60eacab14e55ea3dd06a8890064b7f6ca67ed8d84"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f3cd3f23e50a472528073dcc24ad358e8539874dcf89c527c4d5ff1b6ced941"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f3cd3f23e50a472528073dcc24ad358e8539874dcf89c527c4d5ff1b6ced941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f3cd3f23e50a472528073dcc24ad358e8539874dcf89c527c4d5ff1b6ced941"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7f41d0d4495154fc1936646279525cc9fecfe48dcdde146b60190e3f0f45353"
    sha256 cellar: :any,                 x86_64_linux:      "c1825a6c8f294c597e1981b957a3fdcdb2c680f6ee84debdc0ec1b3d729c5a52"
  end

  depends_on "go" => :build

  # `test do` block runs a local HTTP server
  allow_network_access! :test

  def install
    system "go", "build", *std_go_args, "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = spawn bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db", "--addr", ":#{port}"
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
