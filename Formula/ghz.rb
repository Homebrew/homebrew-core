class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.113.1.tar.gz"
  sha256 "5515be2353f538afd5f51d8ee769dfe46b063582c99fdf892efb2cd3bad83c74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1952abd56ad8da99318d3b4c95acf8d7d68d14134c766a4c6820ad0b01a50588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31612670e266a778fa82f190e3c690748781f5ab0bcb78135243360f611c7e4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40b2a472d3c8b96d841c4b10de9e174827d94a6cecb351a7246cf2c7713b3682"
    sha256 cellar: :any_skip_relocation, ventura:        "c72bd64355d843620c9e036165be3c1014bde067fe77aefab5a33caba5efd629"
    sha256 cellar: :any_skip_relocation, monterey:       "ad995e6b8826a21be008a977b58ddf9859d27ad8022ea97b4f40000bcbe70843"
    sha256 cellar: :any_skip_relocation, big_sur:        "29a1550d10343dbfa17927f742ff9ddeaea84801c104872c77634fe2c4fd0d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92649f7e74a6de06e57088f4442b76ae95b9aff8b9d53cd15362926797b6d5e8"
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
