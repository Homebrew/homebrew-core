class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/23.10/libmediainfo_23.10.tar.xz"
  sha256 "76ebe502e0f310b559d5dd90727d9aafd5fabaaeca3442f38e629dfc07da0d22"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d863478ca270c6a542a5ed059d360900820a17bcf074db845bffc4680bd971c"
    sha256 cellar: :any,                 arm64_ventura:  "e7e0adc022ebef057faf2f97b5355567b25b18db17517a8f6f77ee326c6f8145"
    sha256 cellar: :any,                 arm64_monterey: "f68995ae40dd39a64765d6204855eede4e93e9d0230a904aea1728b850b1888d"
    sha256 cellar: :any,                 sonoma:         "c5c835c7cb50d857e053054991e260105f6960f20c2ef220c6d0219cb3b250ec"
    sha256 cellar: :any,                 ventura:        "c2311b4a08d183634c6b4b8082a2593fadbedc7a1a3b94341c3cecc87df7c215"
    sha256 cellar: :any,                 monterey:       "2a69f6e205101e32d0253914ceb95cd16a53a452278dc5db831ddeab23e6e8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3486a489035f2cfa2f55c98c0844bd46bdc005fa61e678e149be32b42884684c"
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
