class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  revision 1
  head "https://gitlab.kitware.com/cmake/cmake.git"

  stable do
    url "https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0.tar.gz"
    sha256 "b74c05b55115eacc4fa2b77a814981dbda05cdc95a53e279fe16b7b272f00847"

    # Allows CMAKE_FIND_FRAMEWORKS to work with CMAKE_FRAMEWORK_PATH, which brew sets.
    # Remove with 3.18.0.
    patch do
      url "https://gitlab.kitware.com/cmake/cmake/-/commit/c841d43d70036830c9fe16a6dbf1f28acf49d7e3.diff"
      sha256 "87de737abaf5f8c071abc4a4ae2e9cccced6a9780f4066b32ce08a9bc5d8edd5"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e3d804107690769114dff9f807666f7b2aad6a9610423b99188207b3eef03682" => :catalina
    sha256 "f2c6d8483a8a1e07087590b06cdfba7081dc82c9c84c0c38cf932be4e9d9fd94" => :mojave
    sha256 "d9f491b97fed02181a094e2dc96d42b7e01f7f086f88384371279382057dec7b" => :high_sierra
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

    system "./bootstrap", *args, "--", *std_cmake_args
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
