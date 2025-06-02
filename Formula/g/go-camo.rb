class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "c0620c8c23f6e4416bac1f419ee4aafac9b4dafa395e9ae5f26a913be57649ad"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47a6c34d6da6091631c53cc2abcc73bc1051c518e6242332ef1fce057df638b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47a6c34d6da6091631c53cc2abcc73bc1051c518e6242332ef1fce057df638b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f47a6c34d6da6091631c53cc2abcc73bc1051c518e6242332ef1fce057df638b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a624707d989cc04022c3277d7851f2a9731c03e75a0d2cab35b3ea46c0b1968"
    sha256 cellar: :any_skip_relocation, ventura:       "4a624707d989cc04022c3277d7851f2a9731c03e75a0d2cab35b3ea46c0b1968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c050db97720bd69e6371d7fe4c18a05a6dc7f05eb34e3448ce9cacc145ae9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fa1098868849ae81043583c73f72656916a2b3f9c864bd868e0ded8ae38340"
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

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
