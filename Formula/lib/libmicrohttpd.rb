class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.3.tar.gz"
  sha256 "7816b57aae199cf5c3645e8770e1be5f0a4dfafbcb24b3772173dc4ee634126a"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c99ef29c0b7e82e3bb78ba9fdbc10d1e17cbd15ed8a7f198aedbddd7eab2edec"
    sha256 cellar: :any,                 arm64_sequoia: "f5d2524db452325a6cafd07aab7c30041d06f1ce1818055bd0c0ffeddc73fb3b"
    sha256 cellar: :any,                 arm64_sonoma:  "bc7e05326141087cfcaac52829ea3d3f7047352214fb0b5c133d60c2d9963d48"
    sha256 cellar: :any,                 sonoma:        "a7efe951ddcc357cd561ced17193f8d9281eefa4b4073d7ee84b02933e6df25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e0016dfa1d0594197957ab4b8c0d2f3c81317b3b12692236bae79e0e6ecb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c7c153e4ec5ddb2fe2c7ab497eaba55bf8283bb644aba958aae81ea9112e60"
  end

  depends_on "gnutls"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-https",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"examples").install Dir.glob("doc/examples/*.c")
  end

  test do
    cp pkgshare/"examples/simplepost.c", testpath
    inreplace "simplepost.c",
      "return 0",
      "printf(\"daemon %p\", daemon) ; return 0"
    system ENV.cc, "-o", "foo", "simplepost.c", "-I#{include}", "-L#{lib}", "-lmicrohttpd"
    assert_match(/daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo"))
  end
end
