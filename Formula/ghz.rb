class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.92.0.tar.gz"
  sha256 "c2e835ddc61092602d5032789dcb630a564d0c8f804911cdb8cf95c57587466e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eeb4ef807780ea02ec3edc0a5c65c9e011425a7c0ba96375417e5e78f02a5a62"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6df1f56c0fee985d71455ae95501dece15ad0b3c01ce11e6547d4ff48dc3821"
    sha256 cellar: :any_skip_relocation, catalina:      "b2ab72209c5fb74323cbcbe4e77a2c0e22f562ea6523feaaafdb06e21604b719"
    sha256 cellar: :any_skip_relocation, mojave:        "f0ab40089ddcc24fd3537b6c156fbda7ded501aa1e835f10ccf85f760d56caf4"
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
