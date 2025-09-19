class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/25.07/libmediainfo_25.07.tar.xz"
  sha256 "58ece66eaebd9c2fa9b01143c594bce5d21489b8c1dde0dfd2bd13aa7f6266cc"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82cb3af5f25ee92d6686213eea1227293779e7bbba45aa6f7a48ce61d922280b"
    sha256 cellar: :any,                 arm64_sequoia: "b1ef7024b2b2848a888384c283b5229adba6997ad04f5a8eb1cde7f8a672dd2c"
    sha256 cellar: :any,                 arm64_sonoma:  "585de1258b1d6f90589b59e6ef91bcfbe7fc8151a6d0d12b813784a182621a93"
    sha256 cellar: :any,                 arm64_ventura: "36e51984dc329bef1ef295213739a685040bd2ab551f976ee08a835b2b0cb474"
    sha256 cellar: :any,                 sonoma:        "56a4c93092d267ec52c7e3161eeac72c10fe13fdf989feaf14dc134a5cb634ee"
    sha256 cellar: :any,                 ventura:       "5df400dcf45acf202efdaa225df74037181e9ee89f2180a7bc817e25788c9c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21ae6e0afde69fd691c719668e95d4ef12c9529e6c6b8224136cd111059a2ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a288448e00ad879e64554f64085f963d244af652a460b966468b20226d8124a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lmediainfo", "-o", "test"
    system "./test", test_fixtures("test.m4a")
  end
end
