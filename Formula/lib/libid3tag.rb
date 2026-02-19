class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://codeberg.org/tenacityteam/libid3tag"
  license "GPL-2.0-only"
  head "https://codeberg.org/tenacityteam/libid3tag.git", branch: "main"

  stable do
    url "https://codeberg.org/tenacityteam/libid3tag/archive/0.16.3.tar.gz"
    sha256 "0561009778513a95d91dac33cee8418d6622f710450a7cb56a74636d53b588cb"
    # Allow build with CMake 4.0.0
    # Remove on next release.
    patch do
      url "https://codeberg.org/tenacityteam/libid3tag/commit/eee94b22508a066f7b9bc1ae05d2d85982e73959.patch"
      sha256 "f4278e88cb23b0a2aa2bb2c074c6fc2e61029b6d0d77856f4439c3f75f888cbc"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f14fb9815e7191eb7631d5d03761f1122efcc28b49cd90f1901ad87b96604a85"
    sha256 cellar: :any,                 arm64_sequoia: "ddd9d3a16e0104ee19c3e1a0f11e7d2a7e40149806bbef63e54fa2e55b37935b"
    sha256 cellar: :any,                 arm64_sonoma:  "ce8716f0aaf0aa3712ecdfc1ad7b9c9e6de2a49a2ba61855d4f9e8e0fb0e9c6c"
    sha256 cellar: :any,                 sonoma:        "2de45c6c013d4babde517aa9898d8de242b6a2446ef29c86989fd274927b9094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04cbb9cfd78a7d37b1a48898e4f6a96bbb669d09e1629955d78bac408a610fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e865efc2afa8b3a3e14b8379b885ac2148a553de5ba18b5db228cde3dbe0587c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <id3tag.h>

      int main() {
        struct id3_file *fp = id3_file_open("#{test_fixtures("test.mp3")}", ID3_FILE_MODE_READONLY);
        struct id3_tag *tag = id3_file_tag(fp);
        struct id3_frame *frame = id3_tag_findframe(tag, ID3_FRAME_TITLE, 0);
        id3_file_close(fp);

        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs id3tag").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
