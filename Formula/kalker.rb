class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v1.0.1-2.tar.gz"
  sha256 "9f257f2c375a18a8ed988c2047876f5d5dd31adb85b70956fc3c7081d53c9b14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59aa161615f93b2ed5da42d6587c4fa8844cf734d3c62107dfbea4f0cd76472f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b74f005a22c3f9dc700d31e34454de9e212f0c3cf712475e220286ae237422"
    sha256 cellar: :any_skip_relocation, monterey:       "4167e0a6cb7e5d6206ace971aa4b2b11d24f998ef79b52346077730571467a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4cfe4d277d2566381117a943fb0f8779d118c1e229db37e1f87bf7172a008c9"
    sha256 cellar: :any_skip_relocation, catalina:       "d756dbc116f55c88490ea1d5424100ba4beca6248d1614e344f46cc87f8c7a90"
    sha256 cellar: :any_skip_relocation, mojave:         "c391af7964351d031a1fc7f0084a2cded41f1e371c4a0caf1d73c7213b02506c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9707ac9ed288a24c89702ffac6a04dc2eb8b532371830aa8f88ab7b8c9c09626"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(1, 3, 2n+1)'").chomp, "15"
  end
end
