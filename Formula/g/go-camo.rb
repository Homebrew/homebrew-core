class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "3728185aa3dccb2fccc55744f512dbf84bba469fc8eb4f55c59d77177ee1ecf6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e4a0b91027756a54616c0c75dff54e9242358202fcf9273ef18832fd3a7c89a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b47748d98155edb8af811c071ccf59853d743a351981eb079848c96150896d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b47748d98155edb8af811c071ccf59853d743a351981eb079848c96150896d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89b47748d98155edb8af811c071ccf59853d743a351981eb079848c96150896d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec6cf9d0f540510270605fd6a9c094ff0f5f2f66e5a87e82d0e80d56ed3574f9"
    sha256 cellar: :any_skip_relocation, ventura:        "2b15150f12b8ce4bca2ca98f15918fb37d2b898f67f3858d511ee481e8262359"
    sha256 cellar: :any_skip_relocation, monterey:       "2b15150f12b8ce4bca2ca98f15918fb37d2b898f67f3858d511ee481e8262359"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b15150f12b8ce4bca2ca98f15918fb37d2b898f67f3858d511ee481e8262359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff00656ed5e354e8b8edf40469945b82c1d3cb7272cc6967a6dc6a9c0e8c93e"
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
