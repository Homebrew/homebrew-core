class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz"
  sha256 "8c09786ec60ca2be354c29829072c38113de9184f29928eb9da8446a5f2ce6a9"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75a5155277f4a99a4bcd12ca56700abc2054e0dbeb9609c033d090f891a906e6" => :catalina
    sha256 "68e76688af2ffcaa76e59287d7b40ed6970dc57b3268d5886387a77deaf5fcde" => :mojave
    sha256 "f92bf13e0fe260a833b9b1b8fe19f1025a70f6ed43c1f5c07badd70ceb7106b5" => :high_sierra
  end

  depends_on "sphinx-doc" => :build

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    # There is an existing issue around macOS & Python locale setting
    # See https://bugs.python.org/issue18378#msg215215 for explanation
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "./bootstrap", *args, "--", "-DCMAKE_BUILD_TYPE=Release"
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
