class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.63.0.tar.gz"
  sha256 "2912982c761f8484a3cd23b010a294e8a82515d28b2e33748e7f8b7a36c7979a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7e0640fd7bc3b2350db583f9e921c2e414b00727e71055edc6a6c8bd1cb4fe1" => :catalina
    sha256 "649d8aab814136a9285d58127aac446aad04bc76423e029ca39eacdb608c9119" => :mojave
    sha256 "bc9aec8c60daf7a0d6f03acb8bd6dcdce99f8475bf6bda7f2b0bc9ae51b7a9be" => :high_sierra
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
