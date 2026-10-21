class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.12.tar.gz"
  sha256 "028bdfbb066698b5fe5c2a283eea0caca3058ee44c4961d37789445530702c36"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95e45c58f6153b4549ae6eed0538e0bbfa342aac7ec752cc8eeefd8c66ddff17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95e45c58f6153b4549ae6eed0538e0bbfa342aac7ec752cc8eeefd8c66ddff17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95e45c58f6153b4549ae6eed0538e0bbfa342aac7ec752cc8eeefd8c66ddff17"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87112ea5b0e02ec5b4166c12679fc51fec63b5fbc9aaaee873033c7f0ad7077c"
    sha256 cellar: :any,                 x86_64_linux:      "031200b73844b9b8c1a32d1831a3492f594eeabefd70335e9643531890ee6886"
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
