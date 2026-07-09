class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.10.tar.gz"
  sha256 "e93417a833c11885285820990826b406759b122b8d5003c6a5f124e2a2c4013a"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c621cd706b6e625233e3aed1cc86844d44d8e8a877c30c1dd121af228977e7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c621cd706b6e625233e3aed1cc86844d44d8e8a877c30c1dd121af228977e7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c621cd706b6e625233e3aed1cc86844d44d8e8a877c30c1dd121af228977e7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2f046b292231b90c945d6d443a5d5aebf7684c514b69d3078c2a31ab929e788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b56edd3136bda26f7f8bc9235d37c6e9895baecd34b46fcd7a49ac536d5d890"
    sha256 cellar: :any,                 x86_64_linux:  "1bf07cf4d35fbb67c870b69ce143eec4bb515946135c1b4ae1c8bf4d769deff2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

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
