class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.109.0.tar.gz"
  sha256 "4b0b3c651861923a60ca3370de652eb9f3eb5b0c7510c877ec1af8d82508fd08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0be1acbb3926894725f2e0d901a58d21c6bc805eee7c0343159edc22ae4df5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "482538a73d0ab01164b9ed7f5cbf8608b1d680d88e2db1e06ec957bf93053933"
    sha256 cellar: :any_skip_relocation, monterey:       "46ed3f92c8607b1669a2d9a425da7f699d401be229304d60f0b3cde88af2e65b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca61a9e12d67ead1b51baa6bf7637a44b82383b0f4a70621e426fa525b4b7627"
    sha256 cellar: :any_skip_relocation, catalina:       "715dace714bbc077113f4cacee068fde276e75a1522d5310e52b3adb53157b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18d5e6ce6cc3c7455b2e375ec64e4974fca41fe0ccb2fc28d76c3e5f3c87117"
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
