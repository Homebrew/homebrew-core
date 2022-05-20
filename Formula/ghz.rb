class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.108.0.tar.gz"
  sha256 "fd3f4f451ead288622ebf122bb52edf18828a34357489edc8446c64b0cc10770"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c32fcf2d3f8894a1b7473fc7f484cd8d4c4b25df58f772a8fdd8d36e1a14af44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01fedc8ef902f81e16a545e3abdf9d882a534b62ce16749825ae790c63d11c82"
    sha256 cellar: :any_skip_relocation, monterey:       "8d65d5ac5c945561a26687665dfa26dec5f06df44ed017d2190ea9daae6322b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "29ef311cccce505dd3dc1e4659c5a73d1aa52b1eb719cf0b5ff6487576fc90c8"
    sha256 cellar: :any_skip_relocation, catalina:       "62bf78f08a8846ff3b7dafe6413be2349d7a0174bbc01e4b9c2c4c5e1f8bae2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876a984c24cbe9855af0c0023d0d16fb1854e1a089af91492768474f7352c62f"
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
