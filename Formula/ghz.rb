class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.70.0.tar.gz"
  sha256 "8f7ab2443c61b0c666e9ad629546361d69554a6af8682c0ac323802758c983a4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f6d413f89022d24fbe18da2457fa8ea8a2a6eabdf2b01cc0e8b724f13f557d1" => :big_sur
    sha256 "48be94edb841c06b25608492d8d5677cd3947c2f6f55e0bb7bf166da0131b7c3" => :catalina
    sha256 "9ed0e1e1c076b658f80e556da6d9bb8e471099fbb7760f8374a59adb1cf05086" => :mojave
    sha256 "532f9c7cb224ec6e6b4474f675d98a765c011be2dbf3def13ca0e79e4dc59f3b" => :high_sierra
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
