class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.16.3/cmake-3.16.3.tar.gz"
  sha256 "e54f16df9b53dac30fd626415833a6e75b0e47915393843da1825b096ee60668"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb47fab78f567ef95be459336db2da86394e196ce544eee3cfdfa3fbb0861d2d" => :catalina
    sha256 "4244d5f4624f0d16d2a2259b63246ac8c6bb0cf06f84231e65b4b6400a28bc42" => :mojave
    sha256 "7e3d416144b1962929b9f71ed469356b885ee827dd4216bbc78190a897bf6316" => :high_sierra
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
