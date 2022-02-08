class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.1.tar.gz"
  sha256 "e5b2ec78add2a167e1fdc11e3e189dec1bbed2cd9b6e99b3d79c0630b4b83e37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21e95d25630bc3084ae92a9fe95d22ad7cda0828ddeddd6bfe6cc1c91d219b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d821081f56b3955dec2f52492dd0983a7a00ac259fb35cf932390b18dafcf2be"
    sha256 cellar: :any_skip_relocation, monterey:       "3385fb533dbee3029b2bde9b2d4f4aa888f7c9cc2a7eae827c000fb1ac8e7e7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3e9f89bda20018c23ec1f702cea18d2fee6902f2c90c81eb1d0895edf6fd55a"
    sha256 cellar: :any_skip_relocation, catalina:       "dda0e9b6e17e5e6f87655c49c1a3327eb50c95070f6d211a8129008f0de5f1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd58c058668bf83beea9739454e5e302dd3fd4ad20de039dc1bb041a9c21aadb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
