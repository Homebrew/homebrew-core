class LibxdgBasedir < Formula
  desc "C implementation of the XDG Base Directory specifications"
  homepage "https://github.com/devnev/libxdg-basedir"
  url "https://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-1.2.3.tar.gz"
  sha256 "ff30c60161f7043df4dcc6e7cdea8e064e382aa06c73dcc3d1885c7d2c77451d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7aa730f8ebf8aed39fb649f132fe70611b658d3a2d5162bbc073f193c7050b9"
    sha256 cellar: :any,                 arm64_big_sur:  "45fb150350fc290277e2fe56f834065d7694aa1018bc2ffaf2b4a22f20962212"
    sha256 cellar: :any,                 monterey:       "24e93c008e652e67a3e37f2da0e8c937b4dbedc399f3fe1d1cb89ff1dafecc59"
    sha256 cellar: :any,                 big_sur:        "815e73cfc0be4d8091e83b4083bd583e2514a4768c553480d70be1a3e21d77c2"
    sha256 cellar: :any,                 catalina:       "dc5854179a0d219e058f13e294625d4ebd755e82ca2302ce462b33f75d8113c0"
    sha256 cellar: :any,                 mojave:         "228bec555704181d31f3f0baf6d95a5839483d4e16374eef5f91063e29f4e89b"
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
    (testpath/"test.cpp").write <<~EOS
      #include <basedir.h>
      int main() {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) return 1;
        xdgWipeHandle(&handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxdg-basedir", "-o", "test"
    system "./test"
  end
end
