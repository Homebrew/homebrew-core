class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  stable do
    url "https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0.tar.gz"
    sha256 "83b4ffcb9482a73961521d2bafe4a16df0168f03f56e6624c419c461e5317e29"

    # Allow customisation of emacs install directory.
    # Remove with 3.18.1.
    patch do
      url "https://gitlab.kitware.com/cmake/cmake/-/commit/24571e8eca27d6c51ca408f4b834fa930760e1d0.diff"
      sha256 "7234977c8bfa0822bc57867a04f22ecc0347241bb06c7ba99b0d86681c64aa73"
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

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
