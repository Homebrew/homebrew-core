class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.10.0.tar.gz"
  sha256 "be25c6376888b6fb7168746fa3191e17a3b950045552bd9a6eef85f8353facc8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2113d8672e259d7b41f21f6bb724c8080f59f7a0fefea7da07cb4354b82823ab"
    sha256 cellar: :any, arm64_monterey: "d8d26697bca05b66cd24a2f72edf99f24a01eb31053e0306723eb36da29b31e2"
    sha256 cellar: :any, arm64_big_sur:  "731d16ee03f7905447ed708b6d8c3029c2cf39883da5f6294b237ce9e7cbd43b"
    sha256 cellar: :any, ventura:        "dc26899677e909001998a2e9c30e13acc37fb45d93a6cd15265d27564a0ed29c"
    sha256 cellar: :any, monterey:       "d72ed5e00f74a43990141749afa4519425e3af70e444317b51a37e8ed02f7cda"
    sha256 cellar: :any, big_sur:        "2a78af6b0aa0b4e3016622d75d890e7cfde90893c9773df6c5fe1e9ff740087a"
    sha256               x86_64_linux:   "916732cc7f3039ee80d9912f553a82c97e9469547078ce98a0cce7fcf43de4c5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <raqm.h>

      int main() {
        return 0;
      }
    EOS

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end
