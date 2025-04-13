class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/25.03/libmediainfo_25.03.tar.xz"
  sha256 "35f1fdab81239ca355c6de358a84fbde0477fed8eb350e5dfef6a598145c5207"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83d127b2ac85ddad92fc8f333d40fb4f59c63d4cb054408e882fb629385eeb63"
    sha256 cellar: :any,                 arm64_sonoma:  "e6cb06c37412fb00e35c93570ea513e3fb5d21af1c379eb8b94e194cf29beca0"
    sha256 cellar: :any,                 arm64_ventura: "03879b9e0ba513b2d213e9c0a2984db4df18a0da6b27d0fea5d907ee67ef819a"
    sha256 cellar: :any,                 sonoma:        "fbd26e12266f0fa12ff50b40fb5dc7e869759f1b2a13064858f5cba2893c2201"
    sha256 cellar: :any,                 ventura:       "f8f1d37778b317273839b16eadd05748ed46da7b50c1a45c374ef71d9fd7b3bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b6aee421b424cf30ca2d36a8c98906ba79351d3a435dc3de6b48132f13541bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797e671e6bd699ffd9f5c1fe72247af49b8c53815aa4a1d79b6fb2088aaaf507"
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
