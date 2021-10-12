class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.105.0.tar.gz"
  sha256 "c2c257dcdf708e742ff80cd5a1b205991c9192cf857cafc90ed4be8ff2097ee1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d4b32f0b7bbd3325ba02b8631e2c286d39ecb15a8213f702505d21547bed7d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e12c33006960b9b136c1245bf7a2187415cbcedb07cf43d93bb186a7673f9d0"
    sha256 cellar: :any_skip_relocation, catalina:      "bb4207f48ffd0e1f013e16f05e570df3e48e376a8d6ec1e9b3ae6eee5b2d66d2"
    sha256 cellar: :any_skip_relocation, mojave:        "3b3fa63f53a53c87bc14c7c3d5245080a644dfbe2bec2a29c72d0e9f8bf01e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf231ab4cadc4302b50be716b949d5042a89e20442676b82809913d4a54a34b"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~EOS
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    EOS
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
