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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68ca4bf9ef63f4127c5df453aa2ca4162f677d37861a58f4008530428a45b259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1884add4c30123a37bf0e50e44e06992ea68f1cb8cb397de08a0cbd6f8e7a51"
    sha256 cellar: :any_skip_relocation, monterey:       "b8f539f04e0ca3b4c12191daf6a609f9bfef19d7bf6b218944ea20c94557a425"
    sha256 cellar: :any_skip_relocation, big_sur:        "639f607d5f37be5394191898727e381f9c8697b48c3310ca3698d06045dc125d"
    sha256 cellar: :any_skip_relocation, catalina:       "c827cf5bdc7c977318dfc2a595464c4c93358c23cae6b39b526cbac0239003c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4538393aa9ffd8076136aa31a29c181f12d67cc75e2b163ee2f07ed2f6d5fd09"
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
