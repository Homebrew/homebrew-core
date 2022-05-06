class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/23.1.0.tar.gz"
  sha256 "d9d37869f3a941cc4de2d8a6c81f22779401de22a1d25fb860a3a996fa94785c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2608d981bf7ac9a22390eb9509110c2c533891a7e4dc11fe291b8cfda02e215e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2608d981bf7ac9a22390eb9509110c2c533891a7e4dc11fe291b8cfda02e215e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ae4120ebb388d8e1baba642ff63bddbf93d49bd1e8f9548f6eadd3f8e1ad65a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae4120ebb388d8e1baba642ff63bddbf93d49bd1e8f9548f6eadd3f8e1ad65a"
    sha256 cellar: :any_skip_relocation, catalina:       "3ae4120ebb388d8e1baba642ff63bddbf93d49bd1e8f9548f6eadd3f8e1ad65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e447b8709574c549a98e0daf753bb8b181e9e639fed71fe2c9237c2d39576f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end
