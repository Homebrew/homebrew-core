class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.11.tar.gz"
  sha256 "74df2a6983ff1e57be4f0fe4cca66f86b2d9156a399517215ffda69ecc57feac"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f8b6771094221f152c4c92fb0014cd0a07e2bc2f2ea056fbbe0dd8eea1769f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f8b6771094221f152c4c92fb0014cd0a07e2bc2f2ea056fbbe0dd8eea1769f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f8b6771094221f152c4c92fb0014cd0a07e2bc2f2ea056fbbe0dd8eea1769f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dea6c1d74ce17efe284b90e76fc10529273f8e2300c28369d62ba7c4677abf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "392ad1ed39cee16f8e9eb5645ce9fe1b532a57ce16ad4323b6587fc75189d837"
    sha256 cellar: :any,                 x86_64_linux:  "ad30dcccb133c8c52fcfb22256f4cb3c87a0c2afa297c5bb0599c371bf825106"
  end

  depends_on "go" => :build

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
