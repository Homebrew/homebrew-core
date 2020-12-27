class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v4.0.0.tar.gz"
  sha256 "961e14e73d06a015e9b23b8af416f010187cc0bec95f6e3b0fcb28cc7e2cbdd4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "e57dce5b59377e8a411d161ad5f3c774289bcca43cdd36925eb395674cc6ed50" => :big_sur
    sha256 "d0beedd400a16f5bf2feac98a80133673cefce67ce2480de792088a524765110" => :catalina
    sha256 "d15b8408ce94dcc80d4fcfe4d484b65f540a70f8427952c52e2486a985aaae58" => :mojave
    sha256 "1ab02dcf47af9ccdbecc73ead82521f4e14c5d8c24181dd234e6ed822119bdd6" => :high_sierra
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
