class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/23.09/libmediainfo_23.09.tar.xz"
  sha256 "1c326f166572ac6c2c1c88a6d53af7e451388840c7eebeec71d5abbfd1bb2ed3"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "235530751e6ae9e981dad180853f40829aea0dab7bacccdd9b24636d224de284"
    sha256 cellar: :any,                 arm64_monterey: "e267b69bda383aa09252eb0ca30dc558ee03f3b6af382744d913d39d062cb835"
    sha256 cellar: :any,                 arm64_big_sur:  "5be3dad43cea31a065fec924f6d654b6d186f32f95acdcc821b0a7e5e0e5b39d"
    sha256 cellar: :any,                 ventura:        "e5b2e4d963cf1cd8f9a2d9b3c23d1d2205e3f6ad1072dde37f70b29b8884ef2c"
    sha256 cellar: :any,                 monterey:       "40d5c44f4452ebb1d9d6b11f8a685f02e4a298d1556baa3df83aa60370ee808c"
    sha256 cellar: :any,                 big_sur:        "20c579e928b2def52603ef65a4993891e06f8f2b2a206c6ea196b6bb0415f92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8093abdc6b56f33bc187ab294677f087b30235f22b9f3c660a564673e6f4e7eb"
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
