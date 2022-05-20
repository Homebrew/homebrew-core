class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.5.0.tar.gz"
  sha256 "04183106921e3a6aa7c107c6dff6fa13273436e8a26d139e49f34c5d1eea348c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "947f45e4f2792140748229ed6ab17f3f2497b0668c643ffd11cf1d76bac4ee89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4eb0ad59a65cb3c8c870aef3b96754c2ec1b3e62ca79d30bad2abdf746ce9e3"
    sha256 cellar: :any_skip_relocation, monterey:       "36bf279d975a61d82a48e4618c0c925c283f3bdd383e9bf95b443349ae43acbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62799cbbb117b38b1aa7115d9ca4e823caf6eba30bc509638445d82ea7aaa99"
    sha256 cellar: :any_skip_relocation, catalina:       "fd5b46d0b59943d06196923e4ba4f5628816d3c051d3b982939e3e64d2397fdf"
    sha256 cellar: :any_skip_relocation, mojave:         "83a2ca79439aaaa5872597f0d937facea22e69eba196eade49a20099c5b6b120"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f622905f1a8f1ce308b629de6521c17be579de1019a3727ec568a359f852d135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5e7f6ed05b1d96d96059281319cbb3fd5cfb95b7b81c58aa7cfc115698cffb"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/noti", "cmd/noti/main.go"
    man1.install "docs/man/noti.1"
    man5.install "docs/man/noti.yaml.5"
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
