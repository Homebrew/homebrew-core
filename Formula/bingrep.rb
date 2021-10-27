class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.5.tar.gz"
  sha256 "082119e776009b8cb2293b90b49386bfedf2fccaef95130c1f1e3454f6e74e55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ecf4ff1474429313f1234518441308205f0a344a018e0380dc36464bfe7b9a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68702daacc07c6c76ac3f1588a8bf6714af26ee054acdbb01308a2382d53b3a9"
    sha256 cellar: :any_skip_relocation, monterey:       "50815594f499344c09bf09803b3aba698f1bc3effc1c028c800b5fa85baae8de"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4024e1291282371002c7af0a35fcb55e929300b0b60a4b2f97dfd0755af396e"
    sha256 cellar: :any_skip_relocation, catalina:       "bf59cab5aa3c7710fe2910aac21433ff8c10c4101b44df3669783d588178633f"
    sha256 cellar: :any_skip_relocation, mojave:         "3fde029ce5bc7b15c715543091868082ffcdd8f1be4d661061b8256c0289dcba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7e69c3e209fd5c7ed4b1918ac822740948462dced68587a87113b0a155293a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
