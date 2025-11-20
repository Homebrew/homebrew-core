class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/refs/tags/v0.120.0.tar.gz"
  sha256 "e058b1dc3aa09ca7594a79f92bad3b481c4193a0db31b2ac310b54ad802b2580"
  license "Apache-2.0"
  head "https://github.com/bojand/ghz.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6474ad64ea910306bc70ea3b4631b2cf9fe3ecb3cef4407d55c34d5f50b880e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "96497f728b99b55e9e5f780436677c788a862c911cbd04f3c2c0ce68fbd14ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b401ea03c0ecd684e119a75498403d33fb819da7f2d4c846aec1b0f9ece93ce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf690f5896de5d29b8fef7c10584cb20d5dc56cf12966f9438fdf5296463d58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f417a9adde4cb59711d35b85aef26d48b22c6d2c36342bb3164b38c4bd13de7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b5619a75383d5242e401da25dcd2bce75ead6b09fe2cd4d0953c9f6f1da5471"
    sha256 cellar: :any_skip_relocation, ventura:        "aae590227a2a239a67cbfe22676fb3bf1570ac74a958ab90168bc69c32943d5e"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b4eb715afffc5663d43fe8c02bda49e1a4787a333cc60bfb4229ee1f57c309"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "80ea4cc09a406d4890d294bb8f627bee43ccf088d8ecf94ea0ec498e9021353d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5178ebfb4366a1aa75c1dff50167fb9424911c924a3fee0f1f9471c1273ceb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~TOML
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    TOML
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
