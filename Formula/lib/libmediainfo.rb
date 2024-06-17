class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/24.05/libmediainfo_24.05.tar.xz"
  sha256 "b14f79104b1d0d78de9fb42805f29d54fdf01c3e4291cc3638e04d09d145b8d6"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bdf8b8b2c721b88798551ab5289c700d2d6cde65374615892357d43d299e1b7c"
    sha256 cellar: :any,                 arm64_ventura:  "b4c04b07df658ed309e65b0ca7415096b490360d7c7d525bd8e4b73ab3051e65"
    sha256 cellar: :any,                 arm64_monterey: "665f0806b73ad786354a1fc384e5851e97965441ce5cd07484162ab1c4420737"
    sha256 cellar: :any,                 sonoma:         "9c222ed6914e70ea461fd2f017277f61058743ba027b2f747c326dc3ffc7b0c5"
    sha256 cellar: :any,                 ventura:        "1a2d17f9bb82a44d64f34b25f5086040ab8d56faf9a09be587370d9cee2ca3af"
    sha256 cellar: :any,                 monterey:       "6bceba9a47d2d91308eaed6ec7c51804b491b00d832cf3e22bb15fed7f609627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9986f420e50539457615e0ec30be1de47aa243e608c38747a5d07b642b1c26"
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
