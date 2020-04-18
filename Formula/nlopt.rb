class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/v2.6.2.tar.gz"
  sha256 "cfa5981736dd60d0109c534984c4e13c615314d3584cf1c392a155bfe1a3b17e"
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    sha256 "50af59975dda1e54eb42a6d8b9d12177a6aa04ab6949044fbe2fa54d0ddd7181" => :catalina
    sha256 "7a81f1b9a7f5f60d805ce298d1f97b974126a7db3be54bd7471e09de5256f248" => :mojave
    sha256 "232738c4999669c84b8c0c1414a5a89847329c6a9492d8f74f5940f0803688e9" => :high_sierra
    sha256 "00464736f9872cd6a67ee005ba85c1536219e973855c8fa81c46f1515e1409f9" => :sierra
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
