class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.102.0.tar.gz"
  sha256 "b02442f351058d95d48b2166306d7279b6e42b9038823ea1ce75eae24f641f11"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1bbd1a497ffc39f7808eee9296cb315c3801bf3122d4440265dbe11116ec4de"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c3159c75419ad92afc6bcc02dfcb54e1549bf930de046ed277ace0d1e2d2214"
    sha256 cellar: :any_skip_relocation, catalina:      "1b8d06e15f5addfa20e67bd1807e846e0537509f290ff040684f565805f77437"
    sha256 cellar: :any_skip_relocation, mojave:        "8b686d941e36dc39ba64bdffa10b1a3a8a48195ac2c98f6c7c42f5ed244fab54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f8a34a0ca4bcc5d847b271a040f7f57b89b730e487f07fb7f7ceeee50f9ead"
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
