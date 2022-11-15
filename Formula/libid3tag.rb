class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://github.com/tenacityteam/libid3tag/archive/refs/tags/0.16.2.tar.gz"
  sha256 "96198b7c8803bcda44e299615e1929a85bd5a5da02e67ebc442735bc50018190"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea3be63c9af50a5727ffea6b348d2dd1f71e3e1d002923d82d78baafd15833b3"
    sha256 cellar: :any,                 arm64_monterey: "5f3d9e17a9e11f9e7ce446b248031ff52f3ad7a3fe6ca45dfeec015faa3e7720"
    sha256 cellar: :any,                 arm64_big_sur:  "fb715e7759925e8f295d11ec506681abb2f72657ba2394b05c01fb0604c293f2"
    sha256 cellar: :any,                 ventura:        "80ced912c1c8af4628cc7c5c377aca60122d24fe627d59b0aa60c01edd71335b"
    sha256 cellar: :any,                 monterey:       "9b079278969ce8cc27f7740b3a071f1060970164a2e047aeae0167e185eee3ff"
    sha256 cellar: :any,                 big_sur:        "ffeb1df56aa2f9a1cc0e9dda5116cb1017fa3055a47e63eaefc159f5ae5db8a3"
    sha256 cellar: :any,                 catalina:       "110a77d41509a1fe27d1638005f6b903488e7591052e1d0f327555f6e72fcf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d2e52d95f5d011219fe29d4571ec9b27d2acbb8ec9ee1e394ce196fb4abea9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  uses_from_macos "gperf"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <id3tag.h>

      int main(int n, char** c) {
        struct id3_file *fp = id3_file_open("#{test_fixtures("test.mp3")}", ID3_FILE_MODE_READONLY);
        struct id3_tag *tag = id3_file_tag(fp);
        struct id3_frame *frame = id3_tag_findframe(tag, ID3_FRAME_TITLE, 0);
        id3_file_close(fp);

        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs id3tag").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
