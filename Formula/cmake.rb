class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.0/cmake-3.19.0.tar.gz"
  sha256 "fdda688155aa7e72b7c63ef6f559fca4b6c07382ea6dca0beb5f45aececaf493"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url "https://cmake.org/download/"
    regex(/Latest Release \(v?(\d+(?:\.\d+)+)\)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dbefaa3219729cf9a8ad2bf959f58e3a5e8626839b0b9def2e76e7175fc92ac4" => :big_sur
    sha256 "504c4d8e36da1d87ad14f89595f585d8038f34e9668e2f25af4fbbe3794c4c1c" => :catalina
    sha256 "0e0d838403a56af19548b0994fc265bd81f727f5fb30fda8d7723926bb45d0de" => :mojave
  end

  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # Backport patch for 3.19.0: https://gitlab.kitware.com/cmake/cmake/-/issues/21469
  patch do
    url "https://gitlab.kitware.com/cmake/cmake/-/commit/30aa715fac06deba7eaa3e6167cf34eb4d2521d0.patch"
    sha256 "471843b53ea5749eda8b32ef69f9ab20c17e0087992ce3bf8cba93e6e87c54b5"
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
