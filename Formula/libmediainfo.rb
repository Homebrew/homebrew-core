class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/23.06/libmediainfo_23.06.tar.xz"
  sha256 "c6b1ae8b2bbcf403340518b3c94f2ae75c8eb00682bfbbd18b22442e42dccfcd"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f2dcf16bb319c6b5b8acac1f26531031f78acf7262c9a076f814bad5ecbdd6d"
    sha256 cellar: :any,                 arm64_monterey: "c1162dc15219c86c7ee24196d25fb7920ef9b9372f2ce3726279ff8f66c45f33"
    sha256 cellar: :any,                 arm64_big_sur:  "0460ec41a6c2ab02ac8a8e364aca3e580673b385238ae353fa4e9ba97bd86e3d"
    sha256 cellar: :any,                 ventura:        "9a432a210b92e681db1dae18d911bf6e364dc6625850f49c278f9dd5fb147970"
    sha256 cellar: :any,                 monterey:       "6d3dd6bc4158f6285d67fb3fb87b23813e8532e79d4aac30e9fc342cdc5190ab"
    sha256 cellar: :any,                 big_sur:        "ac92a95827b05c857ae1a5a93d45e87a55149508e1300286068cf5e62037730c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ffda9847cfac966144862a7863496399598a34a4ae3d88f0b5158a72c80035"
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
