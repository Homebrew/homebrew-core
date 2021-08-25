class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.101.0.tar.gz"
  sha256 "04caa5789da6162b693dbf1214ed80966ab48b536426717579d65097ae166f54"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6bf5974fcbe7b76ba71d3583815e0e17c88c13c7864b1204e4187cf7c4be8117"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ee90aa10adafc879334eb08bf450f54db08e34baec77ea992b1aad6eabc6fe8"
    sha256 cellar: :any_skip_relocation, catalina:      "c26455cd7b3a3e9646d953a5aaf09fcab93e2771def6c8ae892fd4d85edc9bd7"
    sha256 cellar: :any_skip_relocation, mojave:        "df6b0fb7f585467f067db39c38abf4b4b74011a146140bb9b62196d2ec75b893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330032fa3858d6ab5c10b317e241aea594dca50a0c6c83f51f87133a9dab4ebb"
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
