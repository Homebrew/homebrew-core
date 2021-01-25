class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.10.1.tar.gz"
  sha256 "49f0d61bcca4ac3900dc68fdf11fa325cec6fab6cedde37c5a2ce365b1b46112"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "276da2b191f9f6e3505231f97c1bec04beb57516876ad6a29b58f4ce7c39b5a8" => :big_sur
    sha256 "72063f3cbd49f67e851bf483808f4c08d9052a84c127cf60c73d5f7527459a16" => :catalina
    sha256 "8f70ed6cbfa1bb929a2a10ddcfa0a1cb527eca76abf02bb7d5b723edf981b612" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end
