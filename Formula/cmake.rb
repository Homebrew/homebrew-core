class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1.tar.gz"
  sha256 "fac3915171d4dff25913975d712f76e69aef44bf738ba7b976793a458b4cfed4"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0adf9e1c020361a6f7a2e02d88b6b7d59f23c6487a54240a5ca1ac677501bb4"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ffc49c18cfc6e55a1f61fd62657de2aed1c7debec7e676e5c0160849f391287"
    sha256 cellar: :any_skip_relocation, catalina:      "57dc1f490dd0b29f486d6cfabcd5aafdfc68dc9cc4f093bf1120761aa7d85ae7"
    sha256 cellar: :any_skip_relocation, mojave:        "a7f593d9424c66ed3c2f6a7654c14176bc0ca913d7c676499a74835130cdc6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f1c7452490ddc0eb99c0217d6ec68b1c35e5aa683dfff6aacdace0a29ff147"
  end

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

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
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"

    # Remove deprecated and unusable binary
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20235
    (pkgshare/"Modules/Internal/CPack/CPack.OSXScriptLauncher.in").unlink
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
