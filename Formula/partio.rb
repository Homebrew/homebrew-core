class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.13.0.tar.gz"
  sha256 "a894f2edee2f6c5b186c7563e2f96bb778c71346667c78e0f67583233cd7f3d6"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "2f968d33da264dca45bec37b40d60bac33d47c158e2ba7ccf3c3589c0fdc5535" => :catalina
    sha256 "7b6a89f27d152c1ad4593d9df79e79efa4757058b404802b41e68e5c85191eb9" => :mojave
    sha256 "2a3dbcd7e576aa70904b21e5cee1b733720d2322b1f5ab8fb9064a31b7ed9531" => :high_sierra
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
