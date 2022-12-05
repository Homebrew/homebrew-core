class Libxscrnsaver < Formula
  desc "X.Org: X11 Screen Saver extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.4.tar.xz"
  sha256 "75cd2859f38e207a090cac980d76bc71e9da99d48d09703584e00585abc920fe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81f75d3665b2a25386e48ac4fa26c6ced0dfb309ee9e0c4c3b94397a618a8915"
    sha256 cellar: :any,                 arm64_monterey: "c1a3b96f7cd439165af9e761e489c626778359ae7b32c288ba6b01a934362d0a"
    sha256 cellar: :any,                 arm64_big_sur:  "a7e75a15ac1d4fc2b9dd81a0d0bcb5ae1ff457c52ad5440938e5c3ccc4b6289e"
    sha256 cellar: :any,                 ventura:        "ea6592175b1e14520aeaf7fa8adeac2b6143ee4571164ba805b4bc66121e0443"
    sha256 cellar: :any,                 monterey:       "2154a94f295f404c0fa27d8f6c58e717089fdbe7f8f6736e200e64d35abf1a23"
    sha256 cellar: :any,                 big_sur:        "76e43f0d5a786ac9f6689e2c02956a8519e512dca746f882403fbec960e4291f"
    sha256 cellar: :any,                 catalina:       "d90c91c9058ec7f2bcac9b2b9b83a5dd76096acd88d09c93edee9abaa02707a5"
    sha256 cellar: :any,                 mojave:         "f57eb48a438ab0556e3401ba7b0b049392d11faa2de214ab533e9d444cbf65f2"
    sha256 cellar: :any,                 high_sierra:    "44c025315c63c131e89f1fbb4949a0bae4b56bc76ea9e2db320c058e245a3e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66f775d8f9e82b3e661113eb6287a4b695343642002323192e99d0240bc825e9"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/scrnsaver.h"

      int main(int argc, char* argv[]) {
        XScreenSaverNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
