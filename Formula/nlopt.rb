class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/v2.6.1.tar.gz"
  sha256 "66d63a505187fb6f98642703bd0ef006fedcae2f9a6d1efa4f362ea919a02650"
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6b0c91aa1a690600875d5e00aafa407f2a1394f803b31fde0867d5162a587c15" => :mojave
    sha256 "6865527f6074f1ea737a80bd2b4fd5e6e39df01e744fd111e593fd1dd1c4e0de" => :high_sierra
    sha256 "e3ea4064beff9f39ab2fed6a9e5f643a18fd7abb2b2302713ce7f58f970ceb09" => :sierra
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = *std_cmake_args + %w[
      -DNLOPT_GUILE=OFF
      -DNLOPT_MATLAB=OFF
      -DNLOPT_OCTAVE=OFF
      -DNLOPT_PYTHON=OFF
      -DNLOPT_SWIG=OFF
      -DNLOPT_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    pkgshare.install "test/box.c"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(box C)
      find_package(NLopt REQUIRED)
      add_executable(box "#{pkgshare}/box.c")
      target_link_libraries(box NLopt::nlopt)
    EOS
    system "cmake", "."
    system "make"
    assert_match "found", shell_output("./box")
  end
end
