class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "1aa9a052cd787da3bddbaed90c67210df72b4a615daa79488eac63b8d5beeac9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7db930aad26e38df0d568048470de4d846c5164b5aaefb61210972bd2c5f6787"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7db930aad26e38df0d568048470de4d846c5164b5aaefb61210972bd2c5f6787"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7db930aad26e38df0d568048470de4d846c5164b5aaefb61210972bd2c5f6787"
    sha256 cellar: :any_skip_relocation, sonoma:         "78bc6472492330ae6f4d3ab485c3084c642c6e9efb1c50216b42f85444841c3a"
    sha256 cellar: :any_skip_relocation, ventura:        "78bc6472492330ae6f4d3ab485c3084c642c6e9efb1c50216b42f85444841c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "78bc6472492330ae6f4d3ab485c3084c642c6e9efb1c50216b42f85444841c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73738c6a888a22ecae35f9a953cd3b56540f01893b41ff23f4de4de43cf0440"
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
