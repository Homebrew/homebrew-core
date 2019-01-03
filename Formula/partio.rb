class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.5.5.tar.gz"
  sha256 "25352a6af0ccc20794a8c85715d5a6645c3f8ddcb6bbaaf20136670b5abd4727"

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
  depends_on "swig" => :build

  resource "bgeo" do
    url "https://raw.githubusercontent.com/wdas/partio/dc898054d9144a409fe0e3f8d7f957e1a50ed8a1/src/data/test.bgeo"
    sha256 "b0fe4adcc043d59448cfe690389e45d0f49b6ead675b10d028ca3d70b85999e8"
  end

  def install
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
  end

  test do
    resource("bgeo").stage do
      assert_match "Number of particles:  5", shell_output("#{bin}/partinfo test.bgeo")
    end
  end
end
