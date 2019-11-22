class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.3.0.tar.gz"
  sha256 "494e1a83897bfa9123c8292d0b8501b779b5d31b7f43923b8c48543a5404eb7a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "55373807cc24bc00f1e26855c43cb2d00ea1bfa993c4f61a4368210990a1d5b0" => :catalina
    sha256 "483119c4bf2865ddc52208f33eeb3e8db9e4ff0e5901baf0e441d31492b2a5ff" => :mojave
    sha256 "44d31ac34449acb98d99c65403c6515f4f66f88cb0f0e9f4bed41f31b47107d3" => :high_sierra
    sha256 "2684f0630a200aac31d9ef08f757b431a956534d40776d80599b1a02d80d6ec8" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/noti", "cmd/noti/main.go"
    man1.install "docs/man/noti.1"
    man5.install "docs/man/noti.yaml.5"
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
