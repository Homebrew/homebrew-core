class Libmediainfo < Formula
  desc "Shared library for mediainfo"
  homepage "https://mediaarea.net/en/MediaInfo"
  url "https://mediaarea.net/download/source/libmediainfo/23.09/libmediainfo_23.09.tar.xz"
  sha256 "1c326f166572ac6c2c1c88a6d53af7e451388840c7eebeec71d5abbfd1bb2ed3"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfoLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5dfd7bd4f5255866819cf01b8648e9e01a948c8322884770a9be834b99ea8fbf"
    sha256 cellar: :any,                 arm64_ventura:  "66e0dc31a27e62675271773b42ad215d871a828373035dbe875f832d3ad0d80d"
    sha256 cellar: :any,                 arm64_monterey: "2cd53d452f03c2fc769d6a661120bad1efbe7d5fd2ef599a71780b5036bf8b1f"
    sha256 cellar: :any,                 arm64_big_sur:  "957d0ab748725a6d5d3d2cce2c9068f2dea11abf00f2a37db4cfbb123c50bf63"
    sha256 cellar: :any,                 sonoma:         "1313e646ce266218d744955a0a259722994c1f31d5f6f3a14b4c60a6ce168303"
    sha256 cellar: :any,                 ventura:        "69d4620415867782c9500e84bf829064d2bdec23396b266e73290e360f726018"
    sha256 cellar: :any,                 monterey:       "c75b1c2ae9eb36baa64545d0b7ae0de776de8a7dc29c043ac40d0b3fe2a6f60d"
    sha256 cellar: :any,                 big_sur:        "5d71923c46093e5211b78dd5586d9b241565e921271dd0eb8737453b721a88b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd57b9049934e740c64d0172242f6c22f7c018890c06530d0a454739bf617e1b"
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
