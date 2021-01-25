class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.14.2.tar.gz"
  sha256 "587715eddbe007cbd33f16c89cc3aabc67a69196669b3c6995ce983dc00b54fb"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "831ee848dfaf6e45611274dbaefd5f0debc1202936369b79daf7c55e927de3a4" => :big_sur
    sha256 "46ae27b110fdef6d333d44d10632fead02c88da4bfbbb7a3b625a5b263acba15" => :arm64_big_sur
    sha256 "9b020b08ab6756c1c33f980d850fd9eee05c917edce2d6ccf28e87f30db899dd" => :catalina
    sha256 "91c5ad4566064f72604943b2268fd0434790525324ccf073048519c07da42fd5" => :mojave
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
