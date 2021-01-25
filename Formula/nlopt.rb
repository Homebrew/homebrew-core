class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/v2.7.0.tar.gz"
  sha256 "b881cc2a5face5139f1c5a30caf26b7d3cb43d69d5e423c9d78392f99844499f"
  license "LGPL-2.1"
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    sha256 "255f283f65d458191cfa27b68a827074eaa216f7e7b8159d56921575b0cad1d9" => :big_sur
    sha256 "ff00418c72bb7cd562a176f90eeb9a4a4a4a98ea070e10c5ff83515f57a55e58" => :arm64_big_sur
    sha256 "3bd9fb4ba224bb9167c0412ae4ebc77de6a050427db58fa61c1f9ed2cff0cccd" => :catalina
    sha256 "03a4858507f225ff2df60358206618ce4cd0cb45a047dbe382b3a1429a6b9bb0" => :mojave
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
