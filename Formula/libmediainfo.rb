class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/23.04/libmediainfo_23.04.tar.xz"
  sha256 "3650edea326fe54d3f634614764499508fbeec4ae984002f086adf1d0c071926"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc61a120c71cc0b839779165747970d92b88508960b97cf4d56ecfca62af870e"
    sha256 cellar: :any,                 arm64_monterey: "e11570b29e921d6597c24217c28b9fcd18c1f5756bd7063d1badae3cc7cc7f78"
    sha256 cellar: :any,                 arm64_big_sur:  "8423bfd9b9980c6de5d5770c3b60f8f294ffcc2584cba1d31a4ff59a02689669"
    sha256 cellar: :any,                 ventura:        "0c96ea1123d8d724b9b7ed7333432da6dac16e47f3f5b6fa900499a9bd34606d"
    sha256 cellar: :any,                 monterey:       "1c9fb0266e93d4ea7f660336881ad92479213dbf80e6efc6eb33cfe689a4155b"
    sha256 cellar: :any,                 big_sur:        "d6159471e97d64fcb9a3864e6d8d0d50470604e35d51fd139388712bb40cb791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393b7e38219f28bbc24b7e4651fbda6f0460a875436ca148e0220ce42696258e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"

  # These files used to be distributed as part of the media-info formula
  link_overwrite "include/MediaInfo/*"
  link_overwrite "include/MediaInfoDLL/*"
  link_overwrite "lib/pkgconfig/libmediainfo.pc"
  link_overwrite "lib/libmediainfo.*"

  def install
    system "cmake", "-S", "Project/CMake", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #define _UNICODE
      #include <iostream>
      #include <string>
      #include <filesystem>
      #include <MediaInfo/MediaInfo.h>

      int main(int argc, char* argv[]) {
          std::wstring file_path = std::filesystem::path(argv[1]).wstring();

          MediaInfoLib::MediaInfo media_info;
          size_t open_result = media_info.Open(file_path);
          std::wstring result;

          // Get information about audio streams.
          size_t audio_streams = media_info.Count_Get(MediaInfoLib::stream_t::Stream_Audio);
          for (size_t i = 0; i < audio_streams; ++i) {
              result = media_info.Get(MediaInfoLib::stream_t::Stream_Audio, i, L"Format");
              if (result == L"AAC") {
                  std::cout << "The file contains an audio stream in the m4a (AAC) format." << "\\n";
                  media_info.Close();
                  return 0;
              }
          }

          media_info.Close();
          return 1;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lmediainfo", "-o", "test"
    system "./test", test_fixtures("test.m4a")
  end
end
