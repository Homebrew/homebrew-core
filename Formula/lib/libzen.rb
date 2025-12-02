class Libzen < Formula
  desc "Shared library for libmediainfo"
  homepage "https://github.com/MediaArea/ZenLib"
  license "Zlib"
  revision 1
  head "https://github.com/MediaArea/ZenLib.git", branch: "master"

  stable do
    url "https://mediaarea.net/download/source/libzen/0.4.41/libzen_0.4.41.tar.bz2"
    sha256 "eb237d7d3dca6dc6ba068719420a27de0934a783ccaeb2867562b35af3901e2d"

    # Fixes build with CMake 4.0+. Remove on next release.
    patch do
      url "https://github.com/MediaArea/ZenLib/commit/2350bc442963ba9e4ddcf4e67ba1ff2c95d44635.patch?full_index=1"
      sha256 "fea2e76c5017ab98f2501dfdc24bedf4682b7336544529a08d9e1827c4de6bae"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ac591a473fcc4560644040121ea380ff05b3c9d376cae1e9126c40a62e2daf03"
    sha256 cellar: :any,                 arm64_sequoia:  "de3f0317ed82fd66a7bf6d5a4e876693c932b1a32f2974b02c4abf7b9ab79221"
    sha256 cellar: :any,                 arm64_sonoma:   "c12e982c8e86f4c1fd8b5aeb9e2f29a5f9d4f83c106b0ba68383e43e67fdec5f"
    sha256 cellar: :any,                 arm64_ventura:  "2550179d73b7f536e5684ae85b7487d8e9f5da7eeda4fa4a3008d01a121a9b9e"
    sha256 cellar: :any,                 arm64_monterey: "93295764f863aba841139305a68963d84253c6802905a914094eaad6b7273623"
    sha256 cellar: :any,                 arm64_big_sur:  "4b820f6f232a1f473f07593a9248ab487d7201f7b5b02fab576d6ec552be2f09"
    sha256 cellar: :any,                 sonoma:         "e7eed161ae90ec89df5168da54ba0232341d6731bcad47e5e0443d02345719c2"
    sha256 cellar: :any,                 ventura:        "7e02045ed71e1768d7264b7a99ece14002dcf1964de433db80d503fd23ea59ff"
    sha256 cellar: :any,                 monterey:       "2ed8ddad29956aa083abc3ed7033b45bbc24e978a1eb0bb0ce62cb8befa26e40"
    sha256 cellar: :any,                 big_sur:        "5bc397c5c89a3fd8138e4c52e55815ecf2fb9f7da107aaf5d2c79fa9518304b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e319284f784aa2603799c5500e0a688eb210f11755ec4b8b0114649d82a7ff4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fec7fc988c8b996f28e173e2ca09f561aa9883f9630c60066cb3bdc2d77f60"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  # These files used to be distributed as part of the media-info formula
  link_overwrite "include/ZenLib/*"
  link_overwrite "lib/pkgconfig/libzen.pc"
  link_overwrite "lib/libzen.*"

  def install
    system "cmake", "-S", "Project/CMake", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <ZenLib/Ztring.h>
      #include <iostream>
      int main() {
        ZenLib::Ztring myString = ZenLib::Ztring().From_UTF8("Hello, ZenLib!");
        std::cout << myString.To_UTF8() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lzen", "-o", "test"
    system "./test"
  end
end
