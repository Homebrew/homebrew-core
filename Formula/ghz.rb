class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.95.0.tar.gz"
  sha256 "c41af7b43027d2af3a2aeb0b28353f59995cf295ae013ae15ad952590b9d265a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b1171801cd0ec578426661002265f405e6cd3ea21665ab8635a1cdfe515a1a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c7c8271f08c405eadc272b387db6484a1fa1dfee0cd4b147b3e67141aa44d8f"
    sha256 cellar: :any_skip_relocation, catalina:      "5ee327093bf86c4026ec62279a2d12b7fffa3d785585e8a0bd59988fb661e0b2"
    sha256 cellar: :any_skip_relocation, mojave:        "f9f943f76aecebcbe154b99b787b38edea35c0ba8a294b891ff04e7f4e6d91d7"
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
