class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/24.04/libmediainfo_24.04.tar.xz"
  sha256 "76a6ff060887773f25977b588ae508484bb12d11cb7a2be3322daa9c6e53f1b2"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9bdb6abf4c8d1532dceca703c618452936e36c01357ce16c99f47f9c76b55e7d"
    sha256 cellar: :any,                 arm64_ventura:  "0744e84853e447a28c6acfb1ed0b99903f477a9ae5df554e50080723822e56ae"
    sha256 cellar: :any,                 arm64_monterey: "0738367b43075888b662aa73e03f872256a14b050b223a16102970067e26801c"
    sha256 cellar: :any,                 sonoma:         "f380e7d2b279159675e30803a25b264e69082f1a6bc41f118c078bf134bdce78"
    sha256 cellar: :any,                 ventura:        "e18c046f4619eff3c7e32101aa51603aa3e5499e015a585c30d421bd84ee5bd9"
    sha256 cellar: :any,                 monterey:       "927a7973013d0b4d9bf90b360cfdb96c33e2324286f83fafb89f393c11936873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14b3d9e4dd9dd0f7a24ec7e0df40d65eed5561190dc6bf731bd3a2898446638"
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
