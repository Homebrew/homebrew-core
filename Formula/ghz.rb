class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.111.0.tar.gz"
  sha256 "155a818636d5927bc3975c36a5cfa5ca3e15d6e077986e2a520337e0dd3bb79b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27b541a734588cfaebf1e3a88f6653bb88983b2f01fff8e5360533f373038184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3ecd802bba9b22f7b1672d418d37e84f55aee7f9fd090cc264d30444d50b41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad084b3e17afc494d60133acf620b994eafb0f14dacb054211efb82d492c3f23"
    sha256 cellar: :any_skip_relocation, ventura:        "527b30908e2ea4e6267bafa7febc425463764d8783a86ff80708300524a476ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f29f5b2e9fbb1079a02b5ca6d9b383fdccc9119fc8b47ec7413d75c2be2dd929"
    sha256 cellar: :any_skip_relocation, big_sur:        "7241bcd5e8bf1b0fd196fe053626a410732e34e929da43c6cd69f8b21f5ad25b"
    sha256 cellar: :any_skip_relocation, catalina:       "bdd5e46cf2bc00b8b1ba6aa352e76318f45f9151e878514aca490ccaa5b0a471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418a61657d58a9296018db6547921df25ff97aecb959d1c84475fc4174993e64"
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
