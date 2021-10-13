class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.18.0.tar.gz"
  sha256 "f2d751b3b6e1a1712aae0f639be7a76764469303a55ae5d8881d6535dbe3bd0e"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "850dafa4ddd2e8f33e835da4adef2aa3ef2e6cd5a37ed8bf48bf6da26509e46e"
    sha256 cellar: :any,                 big_sur:       "4b407991ddbb0ef02fbc92721d687ce9e14372a31e6dd65eceac5bff4b9d864c"
    sha256 cellar: :any,                 catalina:      "3995b4d55dac5e712fc7818a8d36dc025218fbd73448da212526225ccbd01be1"
    sha256 cellar: :any,                 mojave:        "ba352fc38689d436baf0eafea5f2d9f95a392fe2f2306bda3f34f2a650ab401c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7982b429b5e2f8186a5e8313c62e36edf7cb1211429519a0d575509dbc2c8dde"
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
