class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.5.tar.gz"
  sha256 "fbc4070b2af4b87e2cff7ce3434f79af04d843594be43bba14293674475ec03c"

  bottle do
    cellar :any
    sha256 "fbee45bf6d442c2846d10019a4e0aa90cf54d9ba1e3fd7a068955b25b2156fb0" => :catalina
    sha256 "c932276f2380adb0931435638641dcce166d2ab542ec7254a6fc4257b9b2f259" => :mojave
    sha256 "799b34ea32419dd37598adeaac9b6b779351cfd91a3dba99c122ba3b518e5a04" => :high_sierra
    sha256 "afdbe6ecf6907a23e1e1b20ec5f24293063cb246cb9da2ff903b353e6604ba28" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
