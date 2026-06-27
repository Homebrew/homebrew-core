class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/26.05/libmediainfo_26.05.tar.xz"
  sha256 "c08b2d87b2fb5edb4526c2a8a317eb1f2cff44807e4631a037ca9f9a1d455054"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40bfb74ab59661516204cad038fb34443c637e91782b55ed8425bdc23770c5e5"
    sha256 cellar: :any,                 arm64_sequoia: "a4aea5ab66ae1ed64e7afb9ec347002280f02b63fde5001d09e7c86b3a267a8a"
    sha256 cellar: :any,                 arm64_sonoma:  "34cf18c0b6ec0fb800573013d3325fba7ed035cee7d253df22e6679f86b48f41"
    sha256 cellar: :any,                 sonoma:        "d1272778c486c622bd29aef8567147b9eba3d5d3666f8a5f45bf64425724295c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9196fc51986b6d2b13b7f78faaf613c141b0fb2e29ea57180f46ba3ac2fb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4420e7bafe9e97662cfb4dcaa97bdc1a2ae57954d74c31c64ec91bd5f5f00dd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmms"
  depends_on "libzen"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # These files used to be distributed as part of the media-info formula
  link_overwrite "include/MediaInfo/*"
  link_overwrite "include/MediaInfoDLL/*"
  link_overwrite "lib/pkgconfig/libmediainfo.pc"
  link_overwrite "lib/libmediainfo.*"

  # Fix build with c++23 capable compilers with older stdlib. Remove with the next release.
  patch do
    url "https://github.com/MediaArea/MediaInfoLib/commit/f90c003eef186c41f8929e4ff5da86861835c1a8.patch?full_index=1"
    sha256 "4a1ad20304c638e8cbd91b9246df8a1bd979104df516b3d5bda749164270230e"
  end

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
