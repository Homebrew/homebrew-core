class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/25.04/libmediainfo_25.04.tar.xz"
  sha256 "ad45ed7c9db7807aa803845ca88bad9526aa8da883a58127e5390aaa2d81bbb1"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7a6a63c51275d03a196ba46853d9f9b643b3619b23ee28cc90f5b37c11fdda9"
    sha256 cellar: :any,                 arm64_sonoma:  "a9ee33756021ae82ab8e208efe7e84b9ad73f2a7b991c175349d9e7486a14eee"
    sha256 cellar: :any,                 arm64_ventura: "94d88eb9a3876d97ed93bb0eea13ebcaa4745166f78b74f2a6eb9f1962f9da4b"
    sha256 cellar: :any,                 sonoma:        "8c98791b35146b240ef8e9b81a17ca7b884843effb22ddb9730ff2c1423d8a30"
    sha256 cellar: :any,                 ventura:       "034550f80eb6d9d7913a3886b92addff34c1f78e7ca781de53bc1724817b5253"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fbff65d4ff52c74656c7052b9d745a28223b81b4eec6502ed7edd70d72a5288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1d0d3285be1b862b4d2633939840143e6d6f3320fc0334e62c4b53f56eb28ec"
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
