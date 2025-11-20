class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "95b2d8ee6fadb601276e9889243d2357fa63164f8bd856fef0f0ef3f42bed26a"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70f7ebfdda2b1b2953725caffef70e8c1ace644daf88c492b1180e4168bbe03c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f7ebfdda2b1b2953725caffef70e8c1ace644daf88c492b1180e4168bbe03c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70f7ebfdda2b1b2953725caffef70e8c1ace644daf88c492b1180e4168bbe03c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9caadc2c279ccf118523789b1632d3898ba616fab7032b3c9b993ffeecdd9d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e0da46f3e85a8d9d11ff4c668d69918f7ec930dbff4f8114a45711d3ed3039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69309c8a4a4a0626ba3992121f48d716ecb0c2bf15ad288cc8d9797490d76e1e"
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
