class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.57.3.tar.gz"
  sha256 "06ee3217e753357db6540f5ce475a0619b5be51b0feeb1dbfe78e4e4d72ffa24"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2baf1ec5972a0587e3749f82f6c270dc139727f0538a00951270babd9fe33671"
    sha256 cellar: :any,                 arm64_sequoia: "283af75b416f67321c2d1b4f0c070745af68b5582f57434d1e93eefe370286d4"
    sha256 cellar: :any,                 arm64_sonoma:  "e858cc89687cf2a7f3568c262fbd8f8b8a4ffe99fea3c2b88477bc4e1a4a7c27"
    sha256 cellar: :any,                 sonoma:        "0b23ceac5b0b2257929f41c05837282d7b406ae677169908d91e581f493f13c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed7b53f14020bd6e315f416dee48d124cc97ac928cbe9441831ea5dbcc84ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c76b912399d9ef5e4aa8fdff036f93db92dd7bc951df55ed2de39ffabcae507"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glfw"
  depends_on "libusb"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].prefix if OS.linux?

    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DCHECK_FOR_UPDATES=false" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
