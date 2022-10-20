class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "4d8f10c1fedd1acc3b46bde27839349a61b77623dad25437d4aa41d41b502660"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "543520ee67489cc6c4e28731ca05c420ee2ad3c15de438a47cf42cb3e8843070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7366a912e43cff9478e1a051b601580bd4616589a741a2eb9425d28d890d9f71"
    sha256 cellar: :any_skip_relocation, monterey:       "d77824c9ac2b0e0b78edfa131a454dbf110aea0a313a68fbef379320bc8ad95e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f99a59edf328ae24411ece62c4564bcff21d2c8f1d8870120bd9d548734ecea"
    sha256 cellar: :any_skip_relocation, catalina:       "d5a925616e9b3d081069c0b5cf073f778e65d8260011522a04270a8038074c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2134bd862c9744203fdf4d6113699f885501d56b26be1fa5e686dc3054465771"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
