class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/v2.7.1.tar.gz"
  sha256 "db88232fa5cef0ff6e39943fc63ab6074208831dc0031cf1545f6ecd31ae2a1a"
  license "LGPL-2.1"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1b9da35eee41e6edae359ce403cf555e7a8b2335ebe78b940c61bbe9516a3c17"
    sha256 cellar: :any,                 arm64_big_sur:  "4f42df05985991ae1a5c41c090936fde6a52cef297667a268ff3d6f6c90622e9"
    sha256 cellar: :any,                 monterey:       "b4fdf154903fc00284e3a37e58bb699ac75a067c355a9ee7efb80c1722b1c522"
    sha256 cellar: :any,                 big_sur:        "062d705f7d1c94fa4dc93ea2aea8a6674c35d94aaf0f22a6fdad10ea8dc2677e"
    sha256 cellar: :any,                 catalina:       "dac5c573f40f2ae2e15ef67bff4a8ec178f7c7b19940500d51a25d993c19e79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760bd7b65c434a8ab61c18f3c036b64ce367de7818edc82785af4f95e80a5460"
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
