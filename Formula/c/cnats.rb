class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.6.1.tar.gz"
  sha256 "4b60fd25bbb04dbc82ea09cd9e1df4f975f68e1b2e4293078ae14e01218a22bf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "223440be48c43cb502eeceb78514c29b0238717cf17de88ab36113762e545c9a"
    sha256 cellar: :any,                 arm64_monterey: "862262c067872cac1476ab24f7f55ce0c0dafc5f54725041d0e5a4e4d10eb0e6"
    sha256 cellar: :any,                 arm64_big_sur:  "0706ceffcf2d56c553da948c2736b04f0e72e1ff8b510a13c0e189bfee7be8ff"
    sha256 cellar: :any,                 ventura:        "000d38458fefeb3fa9ed904de8520194edd218f712d1ee270d40c1d01e862d69"
    sha256 cellar: :any,                 monterey:       "3eb2b9fd6eafb0da1a4edd95161944335384d9a2239d7932fee0b1837d05cab8"
    sha256 cellar: :any,                 big_sur:        "6e2ab1a62323570a24bb87e63de6f94415a032b543603148d6b7821149f9bb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f644c78147ae22f040bef2477d148923f0d56af87075b0d407e7ec8087fa86b1"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
