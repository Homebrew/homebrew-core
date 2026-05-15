class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.7.tar.gz"
  sha256 "6af9c67f16b12f5c9a565df73878b7f7056e79a74bd32f9adea498039a2116c2"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d403ca3c9de0f4096f8287febee1aed0bbd5d82b9611ad8bde2c39127cc29552"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d403ca3c9de0f4096f8287febee1aed0bbd5d82b9611ad8bde2c39127cc29552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d403ca3c9de0f4096f8287febee1aed0bbd5d82b9611ad8bde2c39127cc29552"
    sha256 cellar: :any_skip_relocation, sonoma:        "31a09f8bf672f17a70fa660a39093f5437abbc888d8a753b4b0898790519af82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d10b6eaf8e8f1ce109e960e9d77ee88574e58acf1fbb476f7b6c60ee2b9e6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc67496b159fd9ea7f86520049f571cc8d8037f46de9ae0582f90d77ebd148c1"
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
