class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/24.06/libmediainfo_24.06.tar.xz"
  sha256 "0683f28a2475dc2417205ba528debccc407da4d9fa6516eb4b75b3ff7244e96e"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8f26919e56c446426bea8abe9f8bbb51c6487d2599ad853ce74a90268d590478"
    sha256 cellar: :any,                 arm64_sonoma:   "dfb00a983d0b7a1691aafef218b6417b82605ba291e0367b901b921a23e8d114"
    sha256 cellar: :any,                 arm64_ventura:  "14266e079f02a52815d0938b9b84bbd2afda5f21a1441d0de3b85f716bed763d"
    sha256 cellar: :any,                 arm64_monterey: "4c07f5c3894ea2f267b22ff4bc4b97faad97991a631a45a3e0f48e0c812b21f8"
    sha256 cellar: :any,                 sonoma:         "3e7bd62f61786ac2bf331d385a151f84f72f4ba7f7946f931cc1d7a3965eaba4"
    sha256 cellar: :any,                 ventura:        "1de25cceecfa0fa85dfe280e72b1c7701278bb3f59e510cf37c85774004b1eca"
    sha256 cellar: :any,                 monterey:       "864a8a489f88391f991d3ddcf1d276f143545049970e32da6d1f8cc82d1e30ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c80fc58fa1bc432f8661261873bb431c25ef6c85fc6b46fe5eb665334c179879"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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
