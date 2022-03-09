class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.2.tar.gz"
  sha256 "fbf6ea7e1ed0c92e543c7f5f2343928e185e11e4cba1c7c9d3bfc28d1c323900"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61846ca640b7c59d98e84753fece1bc7d8a3bd7f9e25451bb8ff5bdf1febf1a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0009b587b2f599afb29349691a3a1104a76a21063e1d03cf7d5cb4813f75f05"
    sha256 cellar: :any_skip_relocation, monterey:       "25735f6efd51c6fca8ca01d4febc436f21528b4c2e01956258cf6736abfe254e"
    sha256 cellar: :any_skip_relocation, big_sur:        "55a52711df12f049e0bc2c1ac2b477fa0b5495f4d337b64df22159593ca16f38"
    sha256 cellar: :any_skip_relocation, catalina:       "43e1d025ac54b525e62baa90bc371e0eab724082283fe7064d8dacdde0d55d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4c8cf69d9ca0dae198573b788429080018f11259e509509661d989cb624d41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
