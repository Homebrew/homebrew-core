class Gtl < Formula
  desc "Greg's Template Library of useful classes"
  homepage "https://github.com/greg7mdp/gtl"
  url "https://github.com/greg7mdp/gtl/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1547ab78f62725c380f50972f7a49ffd3671ded17a3cb34305da5c953c6ba8e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07f48a0ff25c60a6fd034c7027aa1cb362fe1aa48e767ddaa16ecbf47e9e68c0"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/btree"
  end

  test do
    cp_r Dir[pkgshare/"btree/*"], testpath
    system ENV.cxx, "btree.cpp", "-std=c++20", "-I#{include}", "-o", "test"
    system "./test"
  end
end
