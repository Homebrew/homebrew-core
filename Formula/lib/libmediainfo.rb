class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/25.09/libmediainfo_25.09.tar.xz"
  sha256 "8562e8ea03e2af8bde27f66d79a0f573859b8f13193ec115abf10f735b313a12"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5016e22e28b23ced083da32bd55e5de19eb1626a0151f0d9bc89f32c251710ca"
    sha256 cellar: :any,                 arm64_sequoia: "e592de313a0120696b0b6de72b110e026f0eb0cfeee83fccfcbb2cf414ab6522"
    sha256 cellar: :any,                 arm64_sonoma:  "29e6dbd6ef9343931c7a76da6059dfb55ac7d0607fd4bff568cf7c19e5b57b33"
    sha256 cellar: :any,                 sonoma:        "58876fe101b9625fdad9f362057b870b58452e367442fffc206e2d80dd42c014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f7827ac6ebab99a444a910d37d4f923e73e4ae069563b23c1f01cc75d587fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbc4a615e4718684a70b30c9507b0465651110dea91c2f6bd3e31e5b2c9d652"
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
