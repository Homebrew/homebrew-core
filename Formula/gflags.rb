class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.2.1.tar.gz"
  sha256 "ae27cdbcd6a2f935baa78e4f21f675649271634c092b1be01469440495609d0e"

  bottle do
    cellar :any
    sha256 "1574a42aa01d89d14396cd7e914c572dfd03aeedacf3b1fde7aa70a3354ad8ae" => :sierra
    sha256 "ee9cd12657a11df873e606421d0d070fe97a216dad2167914f52dbb36086603d" => :el_capitan
    sha256 "f02436e09a92c37d315f12a6336d6e2ee78602ed5221668e331af040ee791722" => :yosemite
  end

  option "with-debug", "Build debug version"
  option "with-static", "Build gflags as a static (instead of shared) library."

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    if build.with? "static"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end
    mkdir "buildroot" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
