class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.90.0.tar.gz"
  sha256 "fbfd832bd81d4ae5b9bcd90b6a441dcfcd63e6519eda16dcab6282ddb06cbc8f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "34091316bd785f93a86e91e728e54cfe734377a5a481fab8c124a34c78382751" => :big_sur
    sha256 "ef3d0edc9966ad84bc0ef49089171f9c713396859dab877e1e8d47e44d668f2b" => :arm64_big_sur
    sha256 "b76d0fa5163d437413fec89811e2318038f45b86996fc9c5c611bb3558abf6ef" => :catalina
    sha256 "bf024a6bc4e36008ce418df7cb8a2b451893ffb3c73826922a7205c4e0a9a7d2" => :mojave
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
