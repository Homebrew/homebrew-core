class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-1.0.1.tar.gz"
  sha256 "a89e09fc9b4de34dde19f4fcb4faaa1ce10299b9908db1132bbfa1de47882b94"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b6b9e3f50d99182aab32438b580f83182cacfa2baa839268ddd83272b6aae0bf"
    sha256 cellar: :any,                 arm64_sonoma:   "a78702c9353f012d0a5a90d5f2d547f3a9e86a8ce14958d73d195d207065e285"
    sha256 cellar: :any,                 arm64_ventura:  "a99ea7af39d9da744e0cbbea017044f1c2c902776e391cafa567030ecdc11526"
    sha256 cellar: :any,                 arm64_monterey: "c1be769ed563cebdb5d757aea93effa91d5ad0925dabcbad0adde31a82edbce0"
    sha256 cellar: :any,                 sonoma:         "3fda597aeaf2624c37ac9786286acf2eefdb9e4178986da41cea3f6ee039f083"
    sha256 cellar: :any,                 ventura:        "ef0dceb639806d7098eb56adc2b6dce9025686ba9a1873dae74288761fabafda"
    sha256 cellar: :any,                 monterey:       "70acab5386e2689227706740afee9a6afe4ec50ec4267b9386d974177e97b423"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d37cc937fe542354d4907f103e6e3cb497e91f9bcc74ec3c26ed1493731adb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a3501d408795303c34902781102f7665197d97b1c1f33ed1c4da2a87c42b8fd"
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
