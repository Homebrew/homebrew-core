class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.8.1.tar.gz"
  sha256 "0f3ee438fb159d3081b38506e51df6406b355eb241c662ca1a3529dac0140b92"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "3b89c9c2a8bc3e5715dfcc62008935550a198b5fcdff82519109e1d1182adabf" => :catalina
    sha256 "4774c1eb6c723346ab3851f3ee40b36f65467f48784424f59c45c198061a6890" => :mojave
    sha256 "9761149bb17d9c4adf4662034473972ef25d1b57c2e242fa4a1cdbccaa5d6466" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "--buildtype=release", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
