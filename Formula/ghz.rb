class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.61.0.tar.gz"
  sha256 "bfb6430e67d8d7e24b4457ea294ff47fdd92e7027a7b0483678513c1e6316164"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ef91a329d1b56bb55dacc3420d68ddeabd16ea36be61a0005d849dcc5ca900f" => :catalina
    sha256 "8b26f0b4b0e470f8b60a47c9b888f55b5cc2e8b88c1ac3e7073d1610078c8130" => :mojave
    sha256 "11e7b6b8095dbb863a805bf7d356b67d0e725173c272b794ac5fcd37b279488f" => :high_sierra
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
