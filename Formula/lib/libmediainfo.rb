class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/24.12/libmediainfo_24.12.tar.xz"
  sha256 "1f4986207f75deb290915e6bf0b33e3e455774305dd266ffe8997c01aad65b27"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37ab3702af71f5ec6cbee0625ee2e908585f0f548ae2e97d054a27664c0d1392"
    sha256 cellar: :any,                 arm64_sonoma:  "0be01fc262831945cd5ad8332eaecb9aadcf1ad2f9d463eed1d164a0b4ff5145"
    sha256 cellar: :any,                 arm64_ventura: "58a271684fbda61328944639e977f072de6bf6fe580a47d025cce9fda0492ab3"
    sha256 cellar: :any,                 sonoma:        "5dd49ef5b9c995051b74ea94523c35397d072f03925c835b5919bcb0f38c9002"
    sha256 cellar: :any,                 ventura:       "ff0bbc1b762514dcfcff2af8cf7f40e48646a90f841f65cfaae75a9b82ba0682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6150128290729582f7f4fece0c111a99639fa08375e4004fbb16d87221d1df5b"
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
