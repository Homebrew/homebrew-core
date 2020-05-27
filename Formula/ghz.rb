class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.54.1.tar.gz"
  sha256 "b1f56a71abd018141f757e12ffc27e6c001acd4e608ae8b17595bce46935e05d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f7cab0c03480a956b6764c5fa25fd213cbea66c23dd67b85322f99ad1bf8a1a" => :catalina
    sha256 "78154dab1359300c271262730234e69cb2f5e80a93923b37e98e60d61ff12b81" => :mojave
    sha256 "a0d6cd5c94bf3b0322c891f211737989caba73779b4c3ba489b94e62c20fa3a4" => :high_sierra
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
