class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https://gabotechs.github.io/graphqxl"
  url "https://github.com/gabotechs/graphqxl/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "11f642476d684b2dc69f4f40fadc679e15ee371d9b479c64407ad08f6cd857ac"
  license "MIT"
  head "https://github.com/gabotechs/graphqxl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "379bf722db2923512ecdb3432f50e55e08d745de72413d2cbc237aa7fe79a38d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9057e3ddcb6a8a1fa798385108f513d9927ee5653ec274945dd38d63b7b3957"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28ef10a54b84d1be7f375e412dd27308171fcc4fad3a8955697b177682db0466"
    sha256 cellar: :any_skip_relocation, sonoma:         "948f00d9446aebb66f0ca97c834da58e94b1a82b87cd8f50ba65882455ceca54"
    sha256 cellar: :any_skip_relocation, ventura:        "cdffb8c2523a1179eee4f39a1cf6f3dc820486323a2c3e0b1e93a7d9727210b7"
    sha256 cellar: :any_skip_relocation, monterey:       "2deab7850a1d7ccbc8bcf27916cc17cc37e000d149436a19252326f958a1fb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87582fe8fe4d2e3540116b399762e492f3c1896f7d66bbaaa91238b24d27d05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.graphqxl"
    test_file.write "type MyType { foo: String! }"
    system bin/"graphqxl", test_file
    assert_equal "type MyType {\n  foo: String!\n}\n\n", (testpath/"test.graphql").read
  end
end
