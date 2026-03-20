class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/26.01/libmediainfo_26.01.tar.xz"
  sha256 "bcd3d2cc12cf108ca0fbad07568b303257e72afd8ff73d05cfe6b7aa0e66a1c5"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?libmediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "92de23d9cb0513aafc55d1e860fd2fd5cf59780dda14ca011ff4f836dfff1cb9"
    sha256 cellar: :any,                 arm64_sequoia: "c4cd843ae3e47edb31386682662256b102c6ba2557552ea64a8382af89522395"
    sha256 cellar: :any,                 arm64_sonoma:  "e872115d8b14dd89cb0e87103a3c88cb2f577c60b80ba00124c347d608c2c0f4"
    sha256 cellar: :any,                 sonoma:        "ab9338fd06ee4243ab5b8b6eb71d6377fdd3b99094a31b88a24c7f6158e3ca4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f3500f3fb67466199cb9e2044e568a940aefdaebcf1f91bdee485c56221bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7dd457a3095977080d1ae88a78e731641790447d533bc41681d7323c156ca53"
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
