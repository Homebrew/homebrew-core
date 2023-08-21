class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "38dfdda60b0a29d0c22b8a2b0ad549b66d554d1e4f076c76722b532aa281d2dd"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a5fbc78f56e52a4936aad2b6b8cf7df79bc025d2fdacb46c215c8d608c5095f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a5fbc78f56e52a4936aad2b6b8cf7df79bc025d2fdacb46c215c8d608c5095f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a5fbc78f56e52a4936aad2b6b8cf7df79bc025d2fdacb46c215c8d608c5095f"
    sha256 cellar: :any_skip_relocation, ventura:        "385a17d4bf85d85ca448a5b80dc5f36c4ed4e76efc5b9f5d350217d66df1fcdb"
    sha256 cellar: :any_skip_relocation, monterey:       "385a17d4bf85d85ca448a5b80dc5f36c4ed4e76efc5b9f5d350217d66df1fcdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "385a17d4bf85d85ca448a5b80dc5f36c4ed4e76efc5b9f5d350217d66df1fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e220fe9c18b40e21f33e2b49ec620a3b5b5d8f962c70aa3e06f0c652b6de45e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
