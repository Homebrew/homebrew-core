class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.80.0.tar.gz"
  sha256 "ac0e071608a93c283405290d33939865bb71082a4c2dcb2780c860683542cda4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4e55911ce7b59023d69167963a2627cd3d76164d84c20744ea6858291909146" => :big_sur
    sha256 "03e64bcbc6600b33e3f6da623558855926ed654715b58e4f61e11ec0a45a92d0" => :arm64_big_sur
    sha256 "e1ee375f88d79c3906be3d075c4cad225a1885b44b8646f960d015652d18efdc" => :catalina
    sha256 "6d1050e494c4df776addf32c53ffefd7869f404e3e290ab94ff9e86273272cc7" => :mojave
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
