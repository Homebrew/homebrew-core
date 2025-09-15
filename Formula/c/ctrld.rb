class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "c29e367304da0d603ce4edd2fae007631656bd3d6b63fa473803dd18449d2d59"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "ctrld", "./cmd/ctrld"
    bin.install "ctrld"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ctrld --help")
  end
end
