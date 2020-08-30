class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.59.0.tar.gz"
  sha256 "132b6d3c6716022f0dfe67e6fbf1cf0311e90b2ab9074b768860a3b9421c8054"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4ceba759177d9396b6c2bb137cb9730bd2a563d3d1bc66eacc98b5d795594b8" => :catalina
    sha256 "45c7ed37bbaac3d6cee3a54d8c6f0195cfa4a2ace2add1648941e09ee4fa7cf0" => :mojave
    sha256 "0a46ee0b8c224f29f35e84a488d89bbe7243c51b3e18064fb776bbdd3e39fc55" => :high_sierra
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
