class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz"
  sha256 "8a211589ea21374e49b25fc1fc170e2d5c7462b795f1b29c84dd0e984301ed7a"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "711bd637c114496bd9fce6ec7c8cbc2efab3441b9b56402c472376772b3fa241" => :catalina
    sha256 "df769c8be61785860e5c60870d522c0504eeb08b229a0d35800c6594038a9485" => :mojave
    sha256 "2e0ab82d0d7dcfb7fb06b8d47582edbd39224c4e0d0f95fda085edad39b56771" => :high_sierra
    sha256 "b723f970d0b6d44a673340525c157c2e52c42e9ea352a5c25fc5e1a84b9865a8" => :sierra
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
