class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.117.0.tar.gz"
  sha256 "33014936ee67f8f139e89e342756d8415880b65c6bb6acb9fbf97132745a1528"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed6aaa212f249a794632cb2a6fbc1a13a8775874de62ae36cd2e9cf8bef11c3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0676bc830c0c52614673be4e8cabad47f037ee73562f6370e7f5b9c195633b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4be4e029a7b0182ac5bdce0ad9191ad0fa0b3979f3c989ded9c9443f965db9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0676bc830c0c52614673be4e8cabad47f037ee73562f6370e7f5b9c195633b28"
    sha256 cellar: :any_skip_relocation, sonoma:         "734c287f31180d41ab59ed2b94a243e39f8aa19adb39309c9a161d84b859701e"
    sha256 cellar: :any_skip_relocation, ventura:        "d303c73c720b7156498358ebfd31b2b0e66ef5259abb305088f116ef71eada2a"
    sha256 cellar: :any_skip_relocation, monterey:       "a797cc8003a2e0e3510fa95e0f34b48bb62b732bd93b6c4c3ea7df248cbe72c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a797cc8003a2e0e3510fa95e0f34b48bb62b732bd93b6c4c3ea7df248cbe72c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f1fd5ef1df0411d6ad0370a7d7e46ce3161638fae7ab03344262ab24b554e5"
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
