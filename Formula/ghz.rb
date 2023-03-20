class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.114.0.tar.gz"
  sha256 "a2461c048731333e792aab915d0f1da626cbb984dc2bffb6cb66a7c22f198363"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8c9e6250e14bc123b93f3d8bfb2cb1d7de7504179ada94db9b9a778249d461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf23dd914628d71f434292e98510fa5819defeadd998562a75d28cfaeb20466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3082ce151bb85a3b9c094e4b096ef3f690a210dfa49a2b43457759431350a39b"
    sha256 cellar: :any_skip_relocation, ventura:        "731cb0a3d044cd9718d539d07160fc9c5d5c6439d34933519f144fe935e33dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "54a1e716582fdb4039d47546b2e5f00b5a63a0016326c903581107e26029ae36"
    sha256 cellar: :any_skip_relocation, big_sur:        "a128d20de7edc391ad22437457638e1e90f60100d4b7b03d0ce9a198c5b65d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fefd962c23e483abbf23eb78537bf3c8d7005a4fa325820ef1a3d2c65e50fa41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/ghz/main.go"
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
