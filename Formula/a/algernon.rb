class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.13.tar.gz"
  sha256 "2cebc53ced698b1e624138ca8ae0b1b57a3ccb7843eada64df1590855a9c59ef"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed06775d160261a7421885cef30bf5790b06c9d3892b43e9785eaa48b1cbc689"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed06775d160261a7421885cef30bf5790b06c9d3892b43e9785eaa48b1cbc689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed06775d160261a7421885cef30bf5790b06c9d3892b43e9785eaa48b1cbc689"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c5084276860ef51214ab0c665860acdf55238c7b833332417a3e814173dec20e"
    sha256 cellar: :any,                 x86_64_linux:      "098a2c9d07bcf8eb13621869fac2ddd95fd73630a06c8754f4a886f45ad6ad38"
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
