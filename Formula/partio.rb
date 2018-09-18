class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.1.0.tar.gz"
  sha256 "133f386f076bd6958292646b6ba0e3db6d1e37bde3b8a6d1bc4b7809d693999d"

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

  # These fixes are upstream and can be removed in the next released version.
  patch do
    url "https://github.com/wdas/partio/commit/5b80b00ddedaef9ffed19ea4e6773ed1dc27394e.diff?full_index=1"
    sha256 "b14b5526d5b61a3dfec7ddd07b54d5a678170b15b3f83687ab1b4151ae0cd5f3"
  end

  patch do
    url "https://github.com/wdas/partio/commit/bdce60e316b699fb4fd813c6cad9d369205657c8.diff?full_index=1"
    sha256 "58dc0b77155b80301595c0b6a439e852f41779a31348f1716f2c9714273c638b"
  end

  patch do
    url "https://github.com/wdas/partio/commit/e557c212b0e8e0c4830e7991541686d568853afd.diff?full_index=1"
    sha256 "b20a25142316cf93c0cc1188508c39a01275cf784d628e9768d5ee1471adbee2"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
  end
end
