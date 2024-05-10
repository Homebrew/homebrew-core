class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/refs/tags/v0.118.0.tar.gz"
  sha256 "179bbc7ee390a6485074cc3c6ed8c2be141e386ba3a24e2b739c0d14ce60215a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d800c027168dc4b213ab6b32dd3866edf590095682bd1de124ce1272f49bd04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0fcf76ab268e808b1bb134614e83823ecd9016ba694197f269ecc627d27f2b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c980ec0db8a15f8c1b4b178f2cfcf1eaa984e5020ec52ad48c981a3c056d0ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "481addc008ea8f306c7ecb3aab2827b0bd86139316159bcf639c4f7a9a5b595f"
    sha256 cellar: :any_skip_relocation, ventura:        "1bdb63234193e3db8ba86c19c3797ac96322bb4dcd43fa80f19be8df423036b5"
    sha256 cellar: :any_skip_relocation, monterey:       "c4d3380c49c4741723df7e5128fe6af50de221477b940f967414819dcc445c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17295125c597ce3c38da1d34454f78225f45a1832b55d98c1e3b2868c2898810"
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
