class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.7/cmake-3.19.7.tar.gz"
  sha256 "58a15f0d56a0afccc3cc5371234fce73fcc6c8f9dbd775d898e510b83175588e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c7eb9a65ded33407128ef9082e53ccf2be554f42fe50f28c52a4d317a467e50"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b4bb369b342520f950062d42fb4338d535eb3d786b3cbf7357ddde694f0e531"
    sha256 cellar: :any_skip_relocation, catalina:      "39393ba4ddd701214e756a2cf032faa4660504c50651a69a46d84b9fb0f95d21"
    sha256 cellar: :any_skip_relocation, mojave:        "ae659249b99dfbe01b8f709b5d4da48cd6dc269e758d3fdb328aa62234ff318e"
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
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
