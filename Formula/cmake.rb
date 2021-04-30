class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz"
  sha256 "aecf6ecb975179eb3bb6a4a50cae192d41e92b9372b02300f9e8f1d5f559544e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b94fa9c13065ce31259621e1ac1ff8f46c0a6ee606a5944f2562ed86c7fcf2a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8b975b0911f9125065459e9b55da2c43fc58485446ec35d8294d2db2ad77972"
    sha256 cellar: :any_skip_relocation, catalina:      "1875ab07ed5843cdc06368ae851ec1232a72bb679f70f816e549acfe5fff6c31"
    sha256 cellar: :any_skip_relocation, mojave:        "0af0a3d97a83dcdece0c5a8ba867d6b199b928f1c4e0a325eef785af6b8f2f1e"
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
