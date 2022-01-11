class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.10.tar.gz"
  sha256 "c1edd48c156df040c834310461e9d40c2fbbd810704d12cb660bf3f9feb259a4"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61520633d7bc785f5a21e742483f934c8ae3bd43a21ac0d48d64e7c3102cdb24"
    sha256 cellar: :any,                 arm64_big_sur:  "5525463a67e00347e8b14281fc6d1e1c302a4d0f34595eade6eab904d0f8adbf"
    sha256 cellar: :any,                 monterey:       "307c682861acff148ebacb2cb89f5df9126043c4e7c8f9d55287b53d8e500cf1"
    sha256 cellar: :any,                 big_sur:        "ebf3aeef8a447edb4d443bc2ab80ff31f685151252ed3848672aed73e9eea003"
    sha256 cellar: :any,                 catalina:       "e0939e315b8ae36349c71773076989098be301de0eef5781b3e7cd1c270f3dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df788d0d68058b9c3853245421d5a24048aef0cb743c70c44aca93882d1a09b3"
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
