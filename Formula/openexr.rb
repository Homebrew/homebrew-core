class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.0.1.tar.gz"
  sha256 "6d14a8df938bbbd55dd6e55b24c527fe9323fe6a45f704e56967dfbf477cecc1"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_big_sur: "b80c2c86f766b5b165558b748ab12958881063f76d6ed593a1f99c8cdf565254"
    sha256 big_sur:       "d11e1254a0cd32d9e85ec006107ff3ecd5a1d8468102bc8aafe7fb24d30cc35a"
    sha256 catalina:      "65fcbe8599da30562d3fed1e1a8060e8107f472cea5c8bb7685f0f2fcc26bed0"
    sha256 mojave:        "ea015fff421cb98c445b8867b97094a840ddb6ccab2cadc034bfe66aaa298bfa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
