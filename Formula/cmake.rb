class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz"
  sha256 "539088cb29a68e6d6a8fba5c00951e5e5b1a92c68fa38a83e1ed2f355933f768"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76de3a5828825352b3b05951df73aea22ddd27fe158d43b8b1e36c51d0641d55" => :mojave
    sha256 "6a8651cbbc0a0c68076a8c7c4f247897caf63ad20be63af3c9e3becc00541a27" => :high_sierra
    sha256 "e1a16c84cc6cc08eb2abc6590ec31b0c50a3375de104fe53066d1603f3c2aee3" => :sierra
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
