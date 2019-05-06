class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz"
  sha256 "215d0b64e81307182b29b63e562edf30b3875b834efdad09b3fcb5a7d2f4b632"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "103cfc24445145ceaa7904d0e894e44227c4f39312c43f24dfcdcebb30f08c92" => :mojave
    sha256 "02df74fbdef6b403675831ad846d2db663b8f0b92ae2a6f845fa57d0c8502f83" => :high_sierra
    sha256 "8e3707258e78dd6e82d52f8d7683661b32e787617c98512ef8cacfd0a8136ae5" => :sierra
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
