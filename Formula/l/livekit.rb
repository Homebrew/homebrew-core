class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "a590df9f2cea01ae08ee5a67844a9ac212908b0c8ed2feaa994b557e0a826f96"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f6df29afc1dd612f52ae692c1a1db8c31ed5b809f146d4ccd2a74b8caf7eac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe6eb9423a7fa32b173e50724ebf65fee302c03d20071040f3bcc23f9e229d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4915add32ec07f657738c2ed0bd9a64fba2877044ad93389ad475a225244df90"
    sha256 cellar: :any_skip_relocation, sonoma:         "27a8a8ab8ff48e9ecd1178240a9a49b1adca5578a0a3e75a76c25b898c90ddae"
    sha256 cellar: :any_skip_relocation, ventura:        "41391904238114a0a8cc523805ba52e2be3f2d14397e0eb8ba52b2cc643aff70"
    sha256 cellar: :any_skip_relocation, monterey:       "b25a56c12f75a7e6601381decc70b27ea2157f11a2993230e671abc095743d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02162e054197f137117b6a2bbaa25ce62c8ef3b03b2e6c19d399a9145aaf496"
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
