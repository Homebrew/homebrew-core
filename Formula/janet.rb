class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.5.1.tar.gz"
  sha256 "abfe69c4b3af355ad37ff315fea529ac88778df357b44522f07b4df9ee4c8a60"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "982851f015cef1507780d0e7e5a2b24fe1e95580a6a6c98e07d071325ae527c5" => :catalina
    sha256 "3df6e8fb647dbf4bc6a7176a733011c7bf3a4e6b57f66d2ee93d0223618527f1" => :mojave
    sha256 "51cc912063970cea3df0b576be4f927d973da6a12af01899c5b342a8988c5909" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "--buildtype=release", "--prefix=#{prefix}"
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
