class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.17.1.tar.gz"
  sha256 "c9357192c4d0d24f08a02aecd14df9dc52174696334e4a2576c0252c27866cb7"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f39cb2b7896ef5d093ee2d0b483c04855398074a7a73c164f100fb6199553cd3"
    sha256 cellar: :any,                 big_sur:       "b0c3a8bed3d30844eeab4f3dc1ad47e79e7056457f79e8930093f151678336bc"
    sha256 cellar: :any,                 catalina:      "2ecdea58a6c4b1500b1c412197b0808729e2c614b306094c9656291da29dea66"
    sha256 cellar: :any,                 mojave:        "24cae06d69e34d7695ffc3f8e93e827ca69aa50e29aee016095ca25294576aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed1228aea077a01805e1aff7f0b61243e17a44fd73b2a6b19733320107f5a1d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
