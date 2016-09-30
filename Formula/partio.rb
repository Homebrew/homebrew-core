class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "http://www.partio.us"
  url "https://github.com/wdas/partio/archive/v1.1.0.tar.gz"
  sha256 "133f386f076bd6958292646b6ba0e3db6d1e37bde3b8a6d1bc4b7809d693999d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1db67357f3ce32f14c84788605a167838753433a1a81e17f40758fb2f2630445" => :sierra
    sha256 "da106b6a4b5667f84b6528081510b12d0da2acb1bfd74afbf3f7af72316afe63" => :el_capitan
    sha256 "a496ac6afbd60f605e2d3347d06a1850ae2617651b748e28c33a7c4c9c3bf957" => :yosemite
    sha256 "78e2ac329d90feb8c0211135d2337b5e754b0cc5d70a4d58ebae3acc8442c32e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "doxygen" => :build

  # These fixes are upstream and can be removed in the next released version.
  patch do
    url "https://github.com/wdas/partio/commit/5b80b00ddedaef9ffed19ea4e6773ed1dc27394e.diff"
    sha256 "f3808c2b8032f35fee84d90ebaaa8f740376129cd5af363a32ea1e0f92d9282a"
  end

  patch do
    url "https://github.com/wdas/partio/commit/bdce60e316b699fb4fd813c6cad9d369205657c8.diff"
    sha256 "144bdd9c8f490a26e1f39cd1f15be06f8fcbe3cdc99d43abf307bfd25dc5402e"
  end

  patch do
    url "https://github.com/wdas/partio/commit/e557c212b0e8e0c4830e7991541686d568853afd.diff"
    sha256 "f73a6db9ab41eb796f929264a47eba7b0c8826e4590f0caa7679c493aa21b382"
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
