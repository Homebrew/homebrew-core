class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "b171a4d485af619e0480680429f31289c06b0746735cd12e005706fb4bbd1e86"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c417b32ea6ba4ce2eefb27530ea8064028c852e3e23584d5b3e2a33108ac58c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f472078a0e0db9641956e162ff0accd338a9bfc9f2bb01f676c30caf200814b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81faf8af0a353396ca4e12c1394da0e10fd20654592800fa71cc385a13a12e44"
    sha256 cellar: :any_skip_relocation, ventura:        "26df9ffa9239b44ff1e45c7e8bf3ff198f39eb3bae201217b2d467c070b4a50a"
    sha256 cellar: :any_skip_relocation, monterey:       "3ba36b166e0942ebd876ffc84b6a36e3d711e63678d56e936c7aceed0bc53a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e80b177b0c17e39331e867f621cf32be02963f42f173469b7f54917762baaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6783a977886c655b5a9aed107ea0e7b8310ad7dba857ecf0e48ea0537df2bd48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
