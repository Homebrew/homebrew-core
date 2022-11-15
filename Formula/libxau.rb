class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXau-1.0.10.tar.xz"
  sha256 "8be6f292334d2f87e5b919c001e149a9fdc27005d6b3e053862ac6ebbf1a0c0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fa639a2a55cf6554d2dbd114a170c72526e5f6f10b233dc9e1e97c2470cb911"
    sha256 cellar: :any,                 arm64_monterey: "c01ab4cba7bbcbbe8cc8690781389393a42b5ff7f8a50228f1b89316c4c63f55"
    sha256 cellar: :any,                 arm64_big_sur:  "3f1c2890d5906b1e7562d6d8fac52f55f92fc88eb606fde7a15585327ed02e92"
    sha256 cellar: :any,                 ventura:        "34026a1f5ada374158fc99879f14fd68481835484df803bf7a87b5f3f73c447b"
    sha256 cellar: :any,                 monterey:       "9d60637b6b9f0f7c7fbc8e44bce8daac33594fc2f22f606dcb1f4974a57e8b2c"
    sha256 cellar: :any,                 big_sur:        "78928694e4cb5d544cae9af4989ed32b54480453dcf2d6c6f2e6b587c50f8b95"
    sha256 cellar: :any,                 catalina:       "1fc57a7cb97c7e4eecbd4b569070c36d12d9dd7f0d185a6513edf3fdc1b5696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d57f6bed7ebef2e678247934adb7f272957db903544c490edde57b7ac6b793"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
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
      #include "X11/Xauth.h"

      int main(int argc, char* argv[]) {
        Xauth auth;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
