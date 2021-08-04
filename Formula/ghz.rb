class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.97.0.tar.gz"
  sha256 "432ff2dde385163e52661415368f5ffb474ee30385e4cea111676c80258449dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "940268978f48f15a1b2c676bee39fe0b7444d7848c6f1fb22b87e79a756fc663"
    sha256 cellar: :any_skip_relocation, big_sur:       "31ec059ecb87f77b36fa6f0f2f592b5c41623bc29f28db44987c3dc1a666452d"
    sha256 cellar: :any_skip_relocation, catalina:      "c7eecde00ca084ae56e827dff4761086eab35a6d3c32a469d9e13107b79ac63b"
    sha256 cellar: :any_skip_relocation, mojave:        "8ea6272976a2f4e55e5ec07fddd2749303005e137ef1109d9d88cdf2f7f6c10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b30da64f801d9b11646ac89a5133b51f188d9222acbf0cd578ef483455abe5f"
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
