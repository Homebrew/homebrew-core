class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.9.0.tar.gz"
  sha256 "826e43bc638b53ec720e93a26f4ead494c6a28006d280609dac6aef09b39283e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "23048011f5f6d2fa3873cf87782cba708deb09fe1e5c06e21f4e1dbfb3ab498e"
    sha256 cellar: :any, arm64_big_sur:  "4d741a5af66aa2e094bb55cd2592ffa2e6ac5f38e064e99eeb16faec7a324866"
    sha256 cellar: :any, monterey:       "df6c8ca6fb30b138e31e998c646aee64673f5083294d96074f3c094818f2a00f"
    sha256 cellar: :any, big_sur:        "aa6b25d03cd705846e465ff578a6fea2a2cb2249cef9092cdfb08d79c563cf5e"
    sha256 cellar: :any, catalina:       "a954e77a4271fb93d16dbeb178913d294fc2eb90370d8367a9bf7b21e373be49"
    sha256               x86_64_linux:   "0d5b7bb663f0c7325333ddf8c70b53f6fb1124f22afaf4bd67bfd2d3afb9b746"
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
