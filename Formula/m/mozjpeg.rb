class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v4.1.4.tar.gz"
  sha256 "8a5018dc93c08a49fba3aff8d1a0be0a3e26460e315d1db45abb64402935e0db"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5eae236dd744a43514e84f9e81a34f745aff976180154e450f29088e8a3e8597"
    sha256 cellar: :any,                 arm64_ventura:  "9db71c017afe831fbdc3c99dc84c335f558abff44d7639df1fd75325df323182"
    sha256 cellar: :any,                 arm64_monterey: "42932db9fa91516e0ae0d9ae2cf024f27ffdf1159aed56edda0f4c2c68620932"
    sha256 cellar: :any,                 arm64_big_sur:  "9179d7b0b9bf7c218e3546124046c5c2047265fa088d28397ba0ec2f9a15423f"
    sha256 cellar: :any,                 sonoma:         "9c332321377180e69183d2964c6d222bb8233c3eb60b7085a72686e9725a608a"
    sha256 cellar: :any,                 ventura:        "87b8ce6db1d34343d7bbfdd2ea166960a1e2e4750ea89f1c7ff1cb5fb90dcc4c"
    sha256 cellar: :any,                 monterey:       "1808adee62eae3a7fbad78896d3999c0216d5088a540f165932f3465b82f103a"
    sha256 cellar: :any,                 big_sur:        "ccdc12799f872c62ff765eae9e1bec5b68a61c5b46ab084bbd99a59609580c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b1aaba2b74c9fb93a658a9cb8438997b0263012a4378c4fef4d72fc062ade2"
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "libpng"

  def install
    mkdir "build" do
      args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
      system "cmake", "..", *args, "-DCMAKE_INSTALL_LIBDIR=#{lib}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
