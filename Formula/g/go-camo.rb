class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "72279e0836f4d4ccdd73c1828f2d680b8c1e42f56a67e75233459aa6d1a6027a"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af0c15a84d50414f7d242c71a733fb18d33b856ded9a21f417cc7ebf64d5a047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0c15a84d50414f7d242c71a733fb18d33b856ded9a21f417cc7ebf64d5a047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af0c15a84d50414f7d242c71a733fb18d33b856ded9a21f417cc7ebf64d5a047"
    sha256 cellar: :any_skip_relocation, sonoma:        "55febc5b14eaa80b0a937bcd03dedf879855d08f86630cc4152f8aad096658a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1121a0839b27bf1f278b2c8b55abff0d9574390830cda0614040f432c337c83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eccf14c9dc9be9c7f5b3488e0937f618af6ef2086ab4c0ba44b5de8216f9d87"
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
