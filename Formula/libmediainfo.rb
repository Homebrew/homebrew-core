class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/23.04/libmediainfo_23.04.tar.xz"
  sha256 "3650edea326fe54d3f634614764499508fbeec4ae984002f086adf1d0c071926"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "786102667949622b0bae2d70c78f9035eaed9043693aa8889b14b5c0a6ba81fa"
    sha256 cellar: :any,                 arm64_monterey: "285126c041840ab1953aa3e90b8957c3c23a4ac7d99d68ab4ff23b084101ac0a"
    sha256 cellar: :any,                 arm64_big_sur:  "bf3d0764de6a94f08bbda4f1ec0e09272214ac9155ace6c67296d9a942142e2a"
    sha256 cellar: :any,                 ventura:        "4581982f0e20f95eae3d0fd5ab40675f5444e2e5fe55dbd181475df880c45967"
    sha256 cellar: :any,                 monterey:       "9e61bc04dcf6e0810213e6769f245eb63624a59f883679857a7ff6d2d998b815"
    sha256 cellar: :any,                 big_sur:        "fafc81fcddc99c38163d26dbe0bd7843e04aea00a9a8f4d5cb05d2f1e9bcdc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d57baaba15e8366d68246d16d52ff6fb4dda8c275b20f6350389849566757e"
  end

  depends_on "cmake" => :build
  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"

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
