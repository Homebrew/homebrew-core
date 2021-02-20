class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.92.0.tar.gz"
  sha256 "c2e835ddc61092602d5032789dcb630a564d0c8f804911cdb8cf95c57587466e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6dabe78a50ecfb650e9998e4d1bc1fe79f706589a7baf28cfd7eea7b925d825d"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb51154cc4f81a3b98c645b609b03de395e94f5c7b48f2b0e2799e235eda13c4"
    sha256 cellar: :any_skip_relocation, catalina:      "e151438d218c25693ed208ba562b832ec29d07d29ee1e0eb7dc5e9cd60b24009"
    sha256 cellar: :any_skip_relocation, mojave:        "fbb89caaef049be3c6b1e64bee8b0f893dd9fd6c7762c0c19ff420e6012f7ab5"
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
