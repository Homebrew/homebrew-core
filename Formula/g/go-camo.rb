class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "d7d17e70c9713831e3e8e307ff4c582eec1f85a5b604707388cc876297f9d2ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee42f6682e1bb040f0898fc08f3abd09682ee0b531404f2ee14d93206653f080"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee42f6682e1bb040f0898fc08f3abd09682ee0b531404f2ee14d93206653f080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee42f6682e1bb040f0898fc08f3abd09682ee0b531404f2ee14d93206653f080"
    sha256 cellar: :any_skip_relocation, sonoma:         "de9c1739c942d10ebb126c7d17cc925e4c9498bbfff9f337414d889652714a2a"
    sha256 cellar: :any_skip_relocation, ventura:        "de9c1739c942d10ebb126c7d17cc925e4c9498bbfff9f337414d889652714a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "de9c1739c942d10ebb126c7d17cc925e4c9498bbfff9f337414d889652714a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcf898fb1641a3e0497115a5c8887ad4582dc5bf8ccdd1be2f8c1690db734bfa"
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
