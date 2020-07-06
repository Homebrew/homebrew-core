class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.55.0.tar.gz"
  sha256 "d968e7841ec5c06bed2ab297308defa8ff268acd1ecdc7c003aebfc593f29d5d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "df24f8e443c984051197b3818effe80d5f9b638a37466325599aeeeeee2d7ea1" => :catalina
    sha256 "a123aedca86b64c0527230b4d3d395688af617adf7cfb8cb95d966921222cba3" => :mojave
    sha256 "aaa35adb266065e4e6dbad474bb891d604e524e6194b6291cb8b1fecf96fa43c" => :high_sierra
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
