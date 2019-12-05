class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.10.1.tar.gz"
  sha256 "49f0d61bcca4ac3900dc68fdf11fa325cec6fab6cedde37c5a2ce365b1b46112"

  bottle do
    cellar :any_skip_relocation
    sha256 "553577c6a9293fbfc098cea8153e6b273e2dc6584db96aa0ea7071be4f6ddd12" => :mojave
    sha256 "42d4fe9271be76bca99f13bc73146328265995f707fdf50d3c274f5a65193cdd" => :high_sierra
    sha256 "1db67357f3ce32f14c84788605a167838753433a1a81e17f40758fb2f2630445" => :sierra
    sha256 "da106b6a4b5667f84b6528081510b12d0da2acb1bfd74afbf3f7af72316afe63" => :el_capitan
    sha256 "a496ac6afbd60f605e2d3347d06a1850ae2617651b748e28c33a7c4c9c3bf957" => :yosemite
    sha256 "78e2ac329d90feb8c0211135d2337b5e754b0cc5d70a4d58ebae3acc8442c32e" => :mavericks
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
