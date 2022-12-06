class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "82d417f9ece6cafdbfb1e342cf1c7cf4390136578dd7c77b4c7995cbbf4792a0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56442361d6b20c84d630cebd8cd7ef5ef24aa4f88b4a627dc4fa346d8bfdddc2"
    sha256 cellar: :any,                 arm64_monterey: "e9dc062a114d69b463b7ec80988249390e6f4111ef0801a618cb0256e3842391"
    sha256 cellar: :any,                 arm64_big_sur:  "57c83221b7d6bc51972c02509eae3d18e54b67c112bb78b5ca90d0e3b871b8f0"
    sha256 cellar: :any,                 ventura:        "83cf37952aa9241ab30838cc324fb4e7eacf1fe22220873c20efce948f2a5a7b"
    sha256 cellar: :any,                 monterey:       "92c89a0f99ae9342a7c4d7b7802bb82085877fa908e78c4d481c1aa38665d4bd"
    sha256 cellar: :any,                 big_sur:        "45d019137c7c4100c87e3f238e597b396546b11c16261cb2cd899c29bfc6cdbe"
    sha256 cellar: :any,                 catalina:       "3c7fb584d06bd818a49d9b80356ff2579183d9d8bb583c77a995bbfe4e5cc82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e610de0068c95b1cf76f0f98c6f03fc4801b98422ea3669e3ad9caf1e76576"
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
