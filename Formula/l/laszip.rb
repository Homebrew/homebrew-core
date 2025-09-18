class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/archive/refs/tags/3.4.4.tar.gz"
  sha256 "6d034bf3a400f81317a5dbad59d1b7ce82d971e887ca22d15813b914f0a5c281"
  license "Apache-2.0"
  head "https://github.com/LASzip/LASzip.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "298cfa48c70ddde871ee4c4ce69dac03a87033fc6984211de80f8ffbab60b8a6"
    sha256 cellar: :any,                 arm64_sequoia:  "f32216b11c820816beb5bda485e46f0ea163222543e705be3d1e41c13758b9c6"
    sha256 cellar: :any,                 arm64_sonoma:   "d24b59e358170d493bd3d48a8ed99a0253195542510c155f5fd7e9bf329bd733"
    sha256 cellar: :any,                 arm64_ventura:  "0a0374c802376297013a20f8af6c2d0f5fc82ff0b7818fea82da2fcc22d02155"
    sha256 cellar: :any,                 arm64_monterey: "402a088a63bc2da1186342b6a88d71b6a86c744b18ee7b35de3ac95fa8b881a8"
    sha256 cellar: :any,                 sonoma:         "1eeb4c8027b05035f4fb2bb3b0fdbb3acd4b6c9844f879dc4395ab5ca0020860"
    sha256 cellar: :any,                 ventura:        "48dca372c53c8af440ff82b56fd5d71b5ab290bddfda5741764a8ba53eac016b"
    sha256 cellar: :any,                 monterey:       "e92cdbac9a9e25e57e27387fda8a8c97da3a7b1c23b725bb3beeaad383fc559a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "30274fa432851f4ca9c57197037455092c5cf26808f763d8ee0d256a090cab1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fc1dd011f2793d3971409a52eeba03e7353141112a441a60fa317c70175856"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/laszipdllexample.cpp", "-L#{lib}", "-I#{include}/laszip",
                    "-llaszip", "-llaszip_api", "-Wno-format", "-ldl", "-o", "test"
    assert_match "LASzip DLL", shell_output("./test -h 2>&1", 1)
  end
end
