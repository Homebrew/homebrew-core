class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.14.1.tar.gz"
  sha256 "fcdb12c4ca414af346f390f81ea6e2417da182656c1c36377237df57b92cfd34"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "b282a98cfed34a5a4d5b30742b0fdc91a65ef2bdf9ac9baf8eadc9f9a5af9322" => :big_sur
    sha256 "d94904ab3a35461f7c31364f93ac3c8cc7dd7b085a5aabd8daf7f5c07d548cea" => :arm64_big_sur
    sha256 "a63bbdac0dcbf8f16679ea086ef4ddabbb95c59369145096f38e2b11c1aca0f6" => :catalina
    sha256 "8bc582ff4cc25fa96bcff5b862d90e08c5d135982938674ad6877c2a55f63016" => :mojave
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
