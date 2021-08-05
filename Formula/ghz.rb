class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.97.0.tar.gz"
  sha256 "432ff2dde385163e52661415368f5ffb474ee30385e4cea111676c80258449dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b837ab7cfcea3118adc9a7598e079a6e5d20263a07cbf6a4e44170a75b29b9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc20e205bbb7eb3259f082e7389483b4a059be6bdfb4449ef81049587c80404a"
    sha256 cellar: :any_skip_relocation, catalina:      "d35a40c75b27921a791fa161f692b721a0bf55bb5eb52bbc15b775a32dacb4d3"
    sha256 cellar: :any_skip_relocation, mojave:        "229a8e8bb7d424f3c9ad9cdb1d6a14bc976a901c85392962309c4f74212b96d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26cbb16842fca6e35b0f871b6d09d7d7c8ae2e78eec9aec43998396f2211a40b"
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
