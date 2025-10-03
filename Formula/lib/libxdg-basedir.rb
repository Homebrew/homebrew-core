class LibxdgBasedir < Formula
  desc "C implementation of the XDG Base Directory specifications"
  homepage "https://github.com/devnev/libxdg-basedir"
  url "https://github.com/devnev/libxdg-basedir/archive/refs/tags/libxdg-basedir-1.2.3.tar.gz"
  sha256 "ff30c60161f7043df4dcc6e7cdea8e064e382aa06c73dcc3d1885c7d2c77451d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "22234a6e02066d75cd724ec788a6a95bf28efef21338f6f5164f3efce25ccfcf"
    sha256 cellar: :any,                 arm64_sequoia:  "830d1609d4a60b66a7de159c17476bd63834bfae62aafb38a37c7c6aac24575f"
    sha256 cellar: :any,                 arm64_sonoma:   "6fb0160f5b6cd2579d154b9a97c459aef54ca27470db7d8fe9dded2e2f208a2e"
    sha256 cellar: :any,                 arm64_ventura:  "63e6eff0ad399d3054cd01b23563674d726fd502cdf0ae468e489427015e9b79"
    sha256 cellar: :any,                 arm64_monterey: "e7aa730f8ebf8aed39fb649f132fe70611b658d3a2d5162bbc073f193c7050b9"
    sha256 cellar: :any,                 arm64_big_sur:  "45fb150350fc290277e2fe56f834065d7694aa1018bc2ffaf2b4a22f20962212"
    sha256 cellar: :any,                 sonoma:         "5610c066d92263607ec017ec5c3fb94aeae21482175b28909b5ed25353ee9760"
    sha256 cellar: :any,                 ventura:        "9c3b62fa19c3169a4641fc9c5d5a3e6700303335c49383bbe58daa23755d34ac"
    sha256 cellar: :any,                 monterey:       "24e93c008e652e67a3e37f2da0e8c937b4dbedc399f3fe1d1cb89ff1dafecc59"
    sha256 cellar: :any,                 big_sur:        "815e73cfc0be4d8091e83b4083bd583e2514a4768c553480d70be1a3e21d77c2"
    sha256 cellar: :any,                 catalina:       "dc5854179a0d219e058f13e294625d4ebd755e82ca2302ce462b33f75d8113c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6211f3d04b552e82d3f0b8fc89494ac42fcc45fa6f7fc6fa05e63893dc929f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d160ef91d8ec2c931defacad6ff525a7e1336f42e8196e0625bc93a266e54f72"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <basedir.h>
      int main() {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) return 1;
        xdgWipeHandle(&handle);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxdg-basedir", "-o", "test"
    system "./test"
  end
end
