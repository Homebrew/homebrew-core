class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/archive/refs/tags/3.5.0.tar.gz"
  sha256 "6e9baac8689dfd2e1502ceafabb20c62b6cd572744d240fb755503fd57c2a6af"
  license "Apache-2.0"
  head "https://github.com/LASzip/LASzip.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "004ad026fd5502a6cc495b0dc8e82e288e4aaa90c02476f960a2154a9b492c99"
    sha256 cellar: :any,                 arm64_sequoia: "92eb7a021b71cb63ed0d1516b4d5c5a04d4ae7e817a053ff8f6a71c4cd19ab58"
    sha256 cellar: :any,                 arm64_sonoma:  "12e26b05aaf259c99dced2f37e8c2fef3bc3d294a9a9f4d1a6cbd78098eb2eb9"
    sha256 cellar: :any,                 sonoma:        "716ccb155ad20714c434c4c30001134bc112b21daec0589e5846a4bdfb1fe859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4da05f65c3a2b04d89bdd483d154c97a4fd89a95830d60900061e8376b3b67e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af201f8e8d02b21611bf7a35d0ca1ccc1cdfbdb86bfff9840cce5fb890894f5e"
  end

  depends_on "cmake" => :build

  # build patch to scope C++ standard flag, upstream pr ref, https://github.com/LASzip/LASzip/pull/122
  patch do
    url "https://github.com/LASzip/LASzip/commit/a2060ce7bbdde90774e067579fbfd1f53837a015.patch?full_index=1"
    sha256 "131816847a2e44df85e34c945e5e60f5112d94e6f9781c25316293832f08510c"
  end

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
