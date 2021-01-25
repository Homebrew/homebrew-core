class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.5.0.tar.gz"
  sha256 "04183106921e3a6aa7c107c6dff6fa13273436e8a26d139e49f34c5d1eea348c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c62799cbbb117b38b1aa7115d9ca4e823caf6eba30bc509638445d82ea7aaa99" => :big_sur
    sha256 "a4eb0ad59a65cb3c8c870aef3b96754c2ec1b3e62ca79d30bad2abdf746ce9e3" => :arm64_big_sur
    sha256 "fd5b46d0b59943d06196923e4ba4f5628816d3c051d3b982939e3e64d2397fdf" => :catalina
    sha256 "83a2ca79439aaaa5872597f0d937facea22e69eba196eade49a20099c5b6b120" => :mojave
    sha256 "f622905f1a8f1ce308b629de6521c17be579de1019a3727ec568a359f852d135" => :high_sierra
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
