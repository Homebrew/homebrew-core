class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.2.1.tar.gz"
  sha256 "50fa29dec01fb4cc5e6365c93fea5e7747506c1fb307233e5f0a82958a50d206"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e82ed03d2901fbe6a1c3bbcbec3dd3887968e4eb6351244ab4c1c8d28f751d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a06d5b2ef8debd6add5999e7fe4989432860adc4f5b92ae9fd142a8e705be77"
    sha256 cellar: :any_skip_relocation, monterey:       "7a435f21597156e951fb9c00b06f02c21188d2488b86f24988b6d6eeec4d3dde"
    sha256 cellar: :any_skip_relocation, big_sur:        "429dffbb7db20a15b3b51300f592368925807165ba5070045bb93fe39e309c72"
    sha256 cellar: :any_skip_relocation, catalina:       "0d822b32d13309c17c2287fd1a22ecb1185defae37b1bf49551e0c0127b0abdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0005624061442a6df78d2d977ec4de3cb0e193b916df91ba42c383dbf9eec7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
