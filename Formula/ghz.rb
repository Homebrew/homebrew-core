class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.61.0.tar.gz"
  sha256 "bfb6430e67d8d7e24b4457ea294ff47fdd92e7027a7b0483678513c1e6316164"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2350053e23ee501a2421db8b2c1904019a80c2cbd2cbb9e10de49688bffa854" => :catalina
    sha256 "cdb414a2c766efcab809dc7c5b29b0258b525d69131e8d33f6ec94760bbb9597" => :mojave
    sha256 "67a082a5ff9d5160588cc6347d92d2caeedb79afe1847d7e4645d15e36315b4f" => :high_sierra
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
