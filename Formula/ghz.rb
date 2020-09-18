class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.60.0.tar.gz"
  sha256 "57b314f373f124fe5501418ab15645da84a8943d9d836430acb4b3e65983c792"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fa715dc67889126add290e9d201486732f34721a57af5f695822ac3e3fa53db" => :catalina
    sha256 "c37c86755c10416fdae46fb7bbe2dc94af1aeeb091f99a0a2b093bb677fac87a" => :mojave
    sha256 "48cee2048b7787f72a1c3033c006f9c78600c075250b4620d6dcc9cefc9aae75" => :high_sierra
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
