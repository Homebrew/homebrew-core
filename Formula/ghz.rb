class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.56.0.tar.gz"
  sha256 "1cacf02130358fba8caef28e4064bd732f48d81f5ea86138b9eeaa1d16028067"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eaab85312a1298eef3829e16632349af15279c660cdcc776537d21f00ef3f37" => :catalina
    sha256 "b03984731d752e9301e534591ca8b7fd5de5475cbf1f234fc082db2ec88a4235" => :mojave
    sha256 "b209501dff0ca65ebce1241a4f77f11091381f185900d090329b43f99c198f75" => :high_sierra
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
