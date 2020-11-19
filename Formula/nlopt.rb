class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/v2.7.0.tar.gz"
  sha256 "b881cc2a5face5139f1c5a30caf26b7d3cb43d69d5e423c9d78392f99844499f"
  license "LGPL-2.1"
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    sha256 "746892bee8cbc07afe835d2f3a06d5fe7f728e2d5b57655a9e4345dd8c4740b0" => :big_sur
    sha256 "67fbb937e618ea96f22cae30d9f71c3abc4d36b8e9b3d48a0ac47074189da936" => :catalina
    sha256 "849095263f9cac072ca976169f1689ed51b04be20f89e219513bcc7db8a01937" => :mojave
    sha256 "aef5b9054a8b604ad90fa7bb689b3daa3b671b9d65f16e53d25b7a9fa8e074d8" => :high_sierra
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
