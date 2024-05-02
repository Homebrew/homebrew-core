class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.13.tar.gz"
  sha256 "6745bac6db8fba38a7220419748644ca5bae85eac76da46ed2f3629a6aed5503"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e5f913d06e101ef8768baed5d58518cf724ecadb07117e47807164001066efa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5f913d06e101ef8768baed5d58518cf724ecadb07117e47807164001066efa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5f913d06e101ef8768baed5d58518cf724ecadb07117e47807164001066efa"
    sha256 cellar: :any_skip_relocation, sonoma:         "37916867509141f388146a0c5542b855cb9094edfd7b6f46947522cf7492b3fa"
    sha256 cellar: :any_skip_relocation, ventura:        "37916867509141f388146a0c5542b855cb9094edfd7b6f46947522cf7492b3fa"
    sha256 cellar: :any_skip_relocation, monterey:       "37916867509141f388146a0c5542b855cb9094edfd7b6f46947522cf7492b3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e67096e80c12dc27cb76d14c3969d78452d2720425b92d0be221c5d74044eb"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    fork do
      exec bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "http://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
