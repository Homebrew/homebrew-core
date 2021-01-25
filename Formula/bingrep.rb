class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.5.tar.gz"
  sha256 "082119e776009b8cb2293b90b49386bfedf2fccaef95130c1f1e3454f6e74e55"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4024e1291282371002c7af0a35fcb55e929300b0b60a4b2f97dfd0755af396e" => :big_sur
    sha256 "68702daacc07c6c76ac3f1588a8bf6714af26ee054acdbb01308a2382d53b3a9" => :arm64_big_sur
    sha256 "bf59cab5aa3c7710fe2910aac21433ff8c10c4101b44df3669783d588178633f" => :catalina
    sha256 "3fde029ce5bc7b15c715543091868082ffcdd8f1be4d661061b8256c0289dcba" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
