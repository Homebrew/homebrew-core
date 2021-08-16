class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.100.0.tar.gz"
  sha256 "59db1c8a167e638e003fc6ba028e0e64aa3c3e4d5a921138b6b1c0bef1b0aa40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7a3cbcb6bf7025f0c718b7abda867c27929a1ee519fc818fce40dd70b6b82fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "74571c177a0d346e8ecb72f07f0103ced7d40028b8d35eed9890c7a5e776d702"
    sha256 cellar: :any_skip_relocation, catalina:      "087143f7a94a8b1cc44a629d9a20b652afb64ceacc87e28db46ee248f58f4058"
    sha256 cellar: :any_skip_relocation, mojave:        "e46869c7f3b622b81d7212d07595b3c2f15da2b34fb8e7796177e40027799edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97483f6af142d5dbe1becc0d4f519d4a21861cc57d558b8fc5bde36e4b631bf"
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
