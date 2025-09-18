class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "fe1fe28b32f97ef97b325ca5d2defb0704da1ef048372ec20e85e1f587e20965"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8b4e6daa401ad46e0f19d5872ad6d352a111cca2e5b9c8934dae408732e0e3d3"
    sha256 cellar: :any, arm64_sequoia: "d48b90b620edcc740cc7bc4e376aebe72185801e12a23163c9c0cc16cab52b2a"
    sha256 cellar: :any, arm64_sonoma:  "32a7ca5337c00b6548d3ae5fe739c42322b70484ef946069d980aad9972180a3"
    sha256 cellar: :any, arm64_ventura: "6d8ea3c293a66a5033b2987d893c846aee131e7dae8c84a946b6d45e13f2367c"
    sha256 cellar: :any, sonoma:        "87951b1179b73a36a04ddef262ff7430ecb5375822b301d85e115f2dd7497a72"
    sha256 cellar: :any, ventura:       "383bff2859b129387ca4c9070b9416198648e45f62612220303cdb2ac8fba572"
    sha256               arm64_linux:   "5bccc8b128378b32f5997841801029716a7a992084eba6ff6c338d2b6e81c681"
    sha256               x86_64_linux:  "07499ccd1d6adce0995710a701155641ed5aec19e0ba7c006bf70568fa4f7883"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <raqm.h>

      int main() {
        return 0;
      }
    C

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end
