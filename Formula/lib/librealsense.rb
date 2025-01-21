class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.56.3.tar.gz"
  sha256 "a18112df0dc0bf442b58fb754f719be1992ddbba154564db5321729ba340c8a9"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ab6629652e192760b9d9f92dff28a7f757f0a3520270d3882e68f8db0c67e69"
    sha256 cellar: :any,                 arm64_sonoma:  "9e1c5408d61e477d72f6ad60504c3db954a65612ed97d5f1e6009bdf6a60c5f4"
    sha256 cellar: :any,                 arm64_ventura: "5a513c1af7e9709eef2cea30f39021e3158e5635680f956d83b36b66646e127d"
    sha256 cellar: :any,                 sonoma:        "d940b9e56d353878c839a10ca9a2298e84ee374778a34b97dc59f635875ec2a2"
    sha256 cellar: :any,                 ventura:       "703d25a4b7c1f12aaec0f0a5669e5f026bcf38fbb37cc4203be67e9a838c65ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b22dcd8cd361829146e951c7b81efe906c500c440367052d90985d8996b4ef1"
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
