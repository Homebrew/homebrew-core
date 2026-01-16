class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "3e4bb9e58e5f9f8fb2e6d4c484a67ad2a98fe0fd355db48e6014d6e993eb0dd2"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5691e88c434caed6dca8cc4b75c3b8c2943416b82408ea0d73699c0a1247422e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5691e88c434caed6dca8cc4b75c3b8c2943416b82408ea0d73699c0a1247422e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5691e88c434caed6dca8cc4b75c3b8c2943416b82408ea0d73699c0a1247422e"
    sha256 cellar: :any_skip_relocation, sonoma:        "86818fa04a43692d9ac5308f6d19fe5de6a1d1ac48754019f326f47f98cb7caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67544498556661ecc88a6d75104df54dcb34388811fd51a1773660651404c26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712e23d1163c434839238f1c7e8709a01345dc9f02b34e9e7428f1e3a30323e4"
  end

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    system "just", "build"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
