class Hellodart < Formula
  desc "Example App"
  homepage "https://github.com/SainathChallagundla/helloDart/archive/v0.0.1.zip"
  url "https://github.com/SainathChallagundla/helloDart/archive/v0.0.1.tar.gz"
  version "0.0.1-start"
  sha256 "28531fce0cd32d3358d683c727d76536de2c0a7c968c19843343fdb5da1c49d4"
  license "MIT"

  depends_on "cmake" => :build

  def install
    bin.install "helloDart"
  end

  test do
    assert_match "helloDart version 1.0.0", shell_output("#{bin}/mytool -v", 2)
  end
end
