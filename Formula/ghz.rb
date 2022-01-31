class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.106.0.tar.gz"
  sha256 "a0ba91b2cb4ade0b1711ef43a7e358b4f27a562a132cc70e686fe2f9a5df36e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8a6d79afa5694cefcd9cc3c3f72c33071c8ccc76eed447d27038f446b42e55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e38b1235a1ebab376be277382c02546cacfe1f9e0a08a8365988b1682b22cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "d9152852174612aff8590723914e3b49024b84b7090c982b5b269ee314559761"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce1a72d4502cee7ea20f115e20a641c8e743f4a3337c3c2d2fd4c55264e14f1b"
    sha256 cellar: :any_skip_relocation, catalina:       "b4ab069a8b10fd6de21f42709ef0f02f438522ae8fe688878b4b1f65938c2424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a451bcc71c45978cd6cd84ce54557a081b1025af4a5a873486d694a38b4902a9"
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
