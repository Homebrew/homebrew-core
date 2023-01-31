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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f6064eca9addcd6fd4fcfd9f61a8882d1f561b30928d617eb2c1989a44d4ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3889262e3ee2a0889ea7ee369f30416511f47e57e952862250299b1d65bd83a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c8b944a5ada365054c1fa908856747daf34c7b1814b9e00b656336a7494db31"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3e63ae811a93fbb7b9c5c6a425e46310f229f6a3bdfabfa0b061d05121f49b"
    sha256 cellar: :any_skip_relocation, monterey:       "b45cb2732b0b19ef015ee793b05ee15ec80fb5c36b32fac8ff316304b707f773"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cab45be2c8ba136353f79190b8cea4e54c38776daf135f3b5636461a535f2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b682c26299e2ac36a398459240aa21e111c79ba02cbd7c99c961810aacf9f8"
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
