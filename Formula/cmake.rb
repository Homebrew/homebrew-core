class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  stable do
    url "https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3.tar.gz"
    sha256 "0bd60d512275dc9f6ef2a2865426a184642ceb3761794e6b65bff233b91d8c40"

    # Allows CMAKE_FIND_FRAMEWORKS to work with CMAKE_FRAMEWORK_PATH, which brew sets.
    # Remove with 3.18.0.
    patch do
      url "https://gitlab.kitware.com/cmake/cmake/-/commit/c841d43d70036830c9fe16a6dbf1f28acf49d7e3.diff"
      sha256 "87de737abaf5f8c071abc4a4ae2e9cccced6a9780f4066b32ce08a9bc5d8edd5"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5498aed6134742450b1237e0f033ff388831a6c06e9d96524b1e14ebceef1cb1" => :catalina
    sha256 "edc5ec271841a8b8558f8d60ef510c7d7abc91e91cc4fb0422389fad99073857" => :mojave
    sha256 "fc6cba3364bbb477e2e4ac53a002a85976a30c437d0dfb39c528342d6d85b0fd" => :high_sierra
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
