class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.5.5.tar.gz"
  sha256 "ff9aee851c75fca28dc8a1e500d456d48fe34ba7046860a951be9d47a2e2afa2"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "80d0efaa1ec5c89b51fb4de755fac7e1fd68a3276c416c0337a5bf8214a66fc2"
    sha256 cellar: :any,                 arm64_monterey: "fce605bcc061ceb6265ef3b60831777b4f351f9c62c03a6b375c89aa507c1378"
    sha256 cellar: :any,                 arm64_big_sur:  "2e1158e168bcab9ea99596891d829af20250ced327df9bdac64a2616b68998b1"
    sha256 cellar: :any,                 ventura:        "9fd9da880501285e4b33fc882d36c690455da3f8deec3087a04abce57c4ab266"
    sha256 cellar: :any,                 monterey:       "fed973ec43b64cc2bd6f53fa9fca1e268927c5864ba7b9c75bc9d66ab0fed482"
    sha256 cellar: :any,                 big_sur:        "68d165ef19b95853000e873814bd7aed8cba65e9db573509411930228694450b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6ff53c5c85a4adffdad105aeb33b41615faf6c87bffdc797ab16b82c0afb70"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
