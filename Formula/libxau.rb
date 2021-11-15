class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXau-1.0.9.tar.bz2"
  sha256 "ccf8cbf0dbf676faa2ea0a6d64bcc3b6746064722b606c8c52917ed00dcb73ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c77eb765b889d6863d4ca9fd1d2d8d37a94d92b6faac51778718cfc33f10f22d"
    sha256 cellar: :any,                 arm64_big_sur:  "c266397e5e2417a4dc5827a504f27153c12a3938a91b19697abf24d3cfba8ac5"
    sha256 cellar: :any,                 monterey:       "49ba22c2891f3db16a0a9695bb06e70dc14362485dc57deb169157b9834ea2e8"
    sha256 cellar: :any,                 big_sur:        "b21411d706ca7a61346e6d9e62bda5fb34e46f5d9ed4ca96b4c52f3f4a1c6ef8"
    sha256 cellar: :any,                 catalina:       "d10771f476b47134c9c3f18a33fb4d4d86c37e2a4d6dbbc87c13b7ffd06c7248"
    sha256 cellar: :any,                 mojave:         "3a34b529a2092bf1aaffc6603056871c2b0c4b8bd1fe728a14ae6b35e8cf3f77"
    sha256 cellar: :any,                 high_sierra:    "15522122382cdc3e364167c71835e4885a0241189be938853cc4744f38e82aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7a733e5d4e05d82227129aadb680501e18ce206de6deaeca422d63b71d96307"
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
