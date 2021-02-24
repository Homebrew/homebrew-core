class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.93.0.tar.gz"
  sha256 "b52d3e6204cc6f34f2ff6175e77225b80657a9b623e9bdba61727d681bb9fd82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a78e9431c5e9ebe85cbecd60e2b34685883e7ebcc348e4758af3127ccfefe97d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8cf1c792be89573f0402881f1e17ddc18d051b6bb9062fcac55b5bdaa5e0881d"
    sha256 cellar: :any_skip_relocation, catalina:      "45ea23781e14b5cc9cb3d5620262b10fc4bf53d313545e99b87a92d68510acf5"
    sha256 cellar: :any_skip_relocation, mojave:        "76bd043c5b6fc2e3244337c5f109a9c21e48190b5ebb681a165749d240653aa2"
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
