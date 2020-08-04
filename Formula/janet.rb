class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.11.3.tar.gz"
  sha256 "60b389b5fcc5969760ec802fa5faf6383e272c769aef4a94e377cfd8376f4a8c"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "864da331114336a348b2ff3ef3c5aecd726f13844df8cb6bc69085ba0daa6394" => :catalina
    sha256 "6446f5e32bffe1349d9a452efe126ac1cd407c28fb33ddef8ced27d138d9b79d" => :mojave
    sha256 "6c387d9057c19cda172241c0cea0bea364c357ac2c1bfaa18718feb25170f4ac" => :high_sierra
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
