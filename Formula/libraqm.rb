class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.9.0.tar.gz"
  sha256 "826e43bc638b53ec720e93a26f4ead494c6a28006d280609dac6aef09b39283e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6834fefcdb4df601516f21cdaa6d51c44b6bf0d465e9e086af8afed1dfff608f"
    sha256 cellar: :any, arm64_monterey: "069e6e0f6bab066c06811c7abd7578404b9eb9ee6833629a2bec9ab2a1f1b743"
    sha256 cellar: :any, arm64_big_sur:  "118bb1b1daaa4360a1399e265463b806a76b34abff36b28b83a27f376347f32b"
    sha256 cellar: :any, ventura:        "99a0c48c9d6994d6556830a8d14c38de553f8c5f7bb978ef0161e40942cdc43c"
    sha256 cellar: :any, monterey:       "958471b39a56ede02728876c421330cb14a112901d436f5f9cc9a2f4fdd2bb9e"
    sha256 cellar: :any, big_sur:        "7d6f5ad30c91463733eedb4db44df068b1265a5e0c03b5254d35ef33a2197a8c"
    sha256 cellar: :any, catalina:       "8b67c3c8fc0ad8885727fae09c08f44ee0764b976527161688db80838b625ec4"
    sha256               x86_64_linux:   "d9a54ed8657f519f1644544b5867b079903768c27e9db8abf7f4355a3fc1b839"
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
