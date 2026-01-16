class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/25.10/libmediainfo_25.10.tar.xz"
  sha256 "ad13d9797b046ce39d0c65a6f81d2aef2429734c21865a6a4c592c7c01f249dd"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f831afa12538128e0b0d83004b2c9be0cef6eab30d6837118274699ac479c6e"
    sha256 cellar: :any,                 arm64_sequoia: "10c35dbc3ecb48c922991992da22f27e507493dc9b441680f9f11ac53231dec9"
    sha256 cellar: :any,                 arm64_sonoma:  "5185766284ec663705a0b2fbde6768b03dc0bf62bc8262a8ca224d27eced2e04"
    sha256 cellar: :any,                 sonoma:        "5a1dd8c19958b0c50ead4cbf7630c19d972ae03ecf9802f50311c8bee2e679e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43f271a81f778f1269ef811b2bc9cdae10505fee5f3c327dee222e8b3da860ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b995875f63d2c24e13cb5acb06ea0390d056babe9846e56d6ee9bc4251dbab16"
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
