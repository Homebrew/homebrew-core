class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.17.1/libjwt-1.17.1.tar.bz2"
  sha256 "1db8ffcd2fc5e0ee750aee8d90aaecf467282a4836c88524f04bb068b1a06d72"
  license "MPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d401018405929b179299529c9ff100ddaf58ab2a8bceb47ca7d85057c3e0ab01"
    sha256 cellar: :any,                 arm64_ventura:  "6cc8b31e9e5df4d95ded09ef7b627e6b1a5b38eda0cef904b569065786399a3e"
    sha256 cellar: :any,                 arm64_monterey: "eeda8958df30e73b8265b31e2805090d626991d52e2b902a0dd2e5d66f907f79"
    sha256 cellar: :any,                 sonoma:         "970142499d0e227ea6511192d66ca058e32f7a656e479ee0391b1b798bc4e5f0"
    sha256 cellar: :any,                 ventura:        "0ff812e7b77b0e9062002888ac5f995f7b1531eaa1086fc7f60e458ce2fb8ff2"
    sha256 cellar: :any,                 monterey:       "4b9afa8a495a47d52610af8b90f07d2c779118dfab47a58b9447acae2b553210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e10b6e84062a8c02d463a84dadd4c1836005357a26b99b997e73d42b76580d6"
  end

  head do
    url "https://github.com/benmcollins/libjwt.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
