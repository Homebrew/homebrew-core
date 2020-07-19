class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  license "BSD-3-Clause"
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

    # Adds macOS 11.0 compatibility.
    # Remove with 3.18.0.
    patch do
      url "https://gitlab.kitware.com/cmake/cmake/-/commit/a0c4c27443afe1c423c08063e2eaf96ffa2f54fb.diff"
      sha256 "7b84bc0dbb71c620939fb1e354f671e1d0007c9c8060ed3f2afe54a11f5e578c"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8546864336108d217502a797033a72568b0325bf739495dff49c39d7f429fd07" => :catalina
    sha256 "a4e96287fc974242d6399ba2e3e040cfc99e7c1f574873e95491c88244744306" => :mojave
    sha256 "32321684bf5d7d4270db1a6c8fe2bb4c5f18e4a3a00fc7b3c628939c842301ff" => :high_sierra
  end

  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

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
