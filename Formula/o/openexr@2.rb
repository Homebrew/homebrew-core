class OpenexrAT2 < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v2.5.8.tar.gz"
  sha256 "db261a7fcc046ec6634e4c5696a2fc2ce8b55f50aac6abe034308f54c8495f55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ae1ca91a7366461c5b30a91cafe68bf36a64a80f3fbea628f86dfbf4f985a81"
    sha256 cellar: :any,                 arm64_monterey: "f7c2ccf2e653530b225b40b9bf1335d6b9d52b012cf8c62d95e3d059467c69be"
    sha256 cellar: :any,                 arm64_big_sur:  "dc090a9d4021cf97628c0e81fe80b88b2a96c1d0551e3a842bfc0881e41553bb"
    sha256 cellar: :any,                 ventura:        "a9f2ac3b4c6e431225d170e56598eed7b519397d5c8b797236cb6326fe337ca4"
    sha256 cellar: :any,                 monterey:       "02e353301cea377a3626c5808dcacca9e56df56d7604387615e3a113e5261db9"
    sha256 cellar: :any,                 big_sur:        "4eff58e68aa817929e3b925bb429825d2b1c2f9ce4885053cd438597aebcb688"
    sha256 cellar: :any,                 catalina:       "ba23000d17c6dd21b2db620aebeb96e04eb6dfd630b9714965b4256ff0d81736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ea5e352139db9724ee3c1c11629a24523bb33d1e0e7d08b8b8f15f455b302c"
  end

  keg_only :versioned_formula

  deprecate! date: "2023-02-04", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
