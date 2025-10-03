class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "d922d589e29585f5f9501b258342747f40506f4cc0cc8abd3ef180a78a431d86"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8736e126920044d15fbc23806856eec68944945a5d381cc040cc567cf27ff47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8736e126920044d15fbc23806856eec68944945a5d381cc040cc567cf27ff47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8736e126920044d15fbc23806856eec68944945a5d381cc040cc567cf27ff47"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c8b6ab49f9935b8fd46b0cd61e45f006c06115f5a46d49d251d39bbacd3892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39ef3c37b22d4f758903560a012e67d6738ea0b4d411f585770d02ca4fa73bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2254743707a4e5f2bcd37858e97b3583a1a36219b7818c2a0df200e94ce1852d"
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
