class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.11.3.tar.gz"
  sha256 "60b389b5fcc5969760ec802fa5faf6383e272c769aef4a94e377cfd8376f4a8c"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "bd57a023531328a0c1f0d30f9a67e1b25280590f0549bf60afba51206ce2f30b" => :catalina
    sha256 "029ee62ab7e7168f484c872a6c1603d7ce1a64a16421d4ce1f49402e97f77edf" => :mojave
    sha256 "bffb15b4c6df0df9158cde841d05c9444e9d166fcc42391c089bd325fd0ce04f" => :high_sierra
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
