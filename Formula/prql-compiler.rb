class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.11.tar.gz"
  sha256 "cf2ea9b7e7a3398998a361a54f2a8c2d5043f754394cff521954dcc22cea5248"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e29934587c3b302eb8e47313722652e577a734222df80a87a1d0616d3825099b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee036e11ced9dc68793b130ee140d2772858f64157fcdce93cd05d002dcb812"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e553a63f7addfdb72822e4151cb4c435b11ee902583194b5bbb26fc8a81f6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "584103d1f40e751c0f6a368b4aa949de898c6d442bbe61be91712463c056dfd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f1f2a630ce7f35f5126fc7cedf99f9624a3185a6db66cae201bc8be011f992"
    sha256 cellar: :any_skip_relocation, catalina:       "1d975d3b9e18c65cc22f39af736a50ec5b8b8cb8fbf8fdd1a90fe902d684f1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d508b251e185f05338e961a0c5158621760550d0e2428df2c8fbe771495baa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
