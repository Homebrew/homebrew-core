class Frozen < Formula
  desc "Header-only, constexpr alternative to gperf for C++14 users"
  homepage "https://github.com/serge-sans-paille/frozen"
  url "https://github.com/serge-sans-paille/frozen/archive/refs/tags/1.1.1.tar.gz"
  sha256 "f7c7075750e8fceeac081e9ef01944f221b36d9725beac8681cbd2838d26be45"
  license "Apache-2.0"
  head "https://github.com/serge-sans-paille/frozen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b2343bd5ac9155af3cc2b82a00e3e45956fcc0476c3590073de076fafe60ee6f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/pixel_art.cpp", testpath

    system ENV.cxx, "pixel_art.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
