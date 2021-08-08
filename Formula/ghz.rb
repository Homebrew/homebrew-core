class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.99.0.tar.gz"
  sha256 "474c84f9d8cf7da5db177f12b0f0f242b500ff42363323bed39f73b4a318bcc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4da04f1d5eb48d972b84107b8ad425ca281339fc8c4a06767cfc175f37782523"
    sha256 cellar: :any_skip_relocation, big_sur:       "f367f641215c874d98de4e45d1f90fa4a0f76bc7295c48b87a8797251eea3aad"
    sha256 cellar: :any_skip_relocation, catalina:      "23061eae569b4cf1df435b69db53d724fc6bd5d30ac6f7e5633cff4f3743d49e"
    sha256 cellar: :any_skip_relocation, mojave:        "9aba96ad3e4e86e4df9ba5af95cfca711290b439ddf86945ab43c54f9fecaa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af5e9932875d9dd7e31027131c2d65369b1506a4b109a877406f9f923a10f85"
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
