class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v4.0.1.tar.gz"
  sha256 "01891901707c6430caaea7e645ff5ac6980cae166094a6f924ded197e5774a19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31e999231a6b8b4fb6eeb008879da217ccf913de62f59faa3fc1c9a190760e06"
    sha256 cellar: :any,                 arm64_big_sur:  "3ed053460c2aa93b1af04ba78ac4e3dda4d21f2052075f33b91c9a38c6fc66e5"
    sha256 cellar: :any,                 monterey:       "e1d529c7526515ea1a3f027fcad335046b4c6e041e0ce18089105f01ca3cebb4"
    sha256 cellar: :any,                 big_sur:        "11ae4107669832bc45e2c1a104c4d531a5385a5540e4e0b21371f11e07af7401"
    sha256 cellar: :any,                 catalina:       "cf0ee74ec6ee5ddc6248c4c6b7f50d7a63c8fc0df035005245d12829438d6ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcbe1de6b6f9d0eb273ed27b79b9fe1c7e952b6b7c0faf145b4333f8d574fea5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
