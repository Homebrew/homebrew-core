class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/24.01/libmediainfo_24.01.tar.xz"
  sha256 "a02dfc6689f485cec06fa12a3414c3c3aa2853b4dde18aeab4b54a56c8316259"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e7ab4f05ac90dd3a88986779f84157b879f08aaa741f66c50cea5b4b6189e82"
    sha256 cellar: :any,                 arm64_ventura:  "4901566d0f75cdf103c90977f431292792cc951caf3550072f07bbbceaff61bc"
    sha256 cellar: :any,                 arm64_monterey: "767ef1cb0fd344a1aa21e99cdeb9510c16681112dee93126846bbe9f33666ddd"
    sha256 cellar: :any,                 sonoma:         "eb41f8a74b45bf1ad8fd8d1fe7587e06d9de5bc9e2fb130b145a09a664bf1a2c"
    sha256 cellar: :any,                 ventura:        "a69785ba460faa89fa342711db3d270e624716eee7a8035fda0024978fbac4aa"
    sha256 cellar: :any,                 monterey:       "1eca8bea89651178ba0fb05516b7477f5c94a302eefc34a3aaf907cff59e59e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f046854043aa8a8036e756d7d734d4e297e9e07aee3dee1c9d3fbb2d6e2c4b"
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
