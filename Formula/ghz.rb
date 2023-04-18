class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.115.0.tar.gz"
  sha256 "ca752eb323f973f7e987d5a51e0d5427d753e4376873bd81c23889d6321b231a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32a7122cec0bb53a925bc62ad4031cff0853edc4f69dd9f27e9a23e5a915fdf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a7122cec0bb53a925bc62ad4031cff0853edc4f69dd9f27e9a23e5a915fdf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32a7122cec0bb53a925bc62ad4031cff0853edc4f69dd9f27e9a23e5a915fdf9"
    sha256 cellar: :any_skip_relocation, ventura:        "d5c4502f12f42ee498e1573943c33895aa3ba64b2ba492bc66c8e893e0286baa"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c4502f12f42ee498e1573943c33895aa3ba64b2ba492bc66c8e893e0286baa"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5c4502f12f42ee498e1573943c33895aa3ba64b2ba492bc66c8e893e0286baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c43280e2ddff71c443872130d7d7d77113ed3b7c1afd03ab16030ca886b41a4a"
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
