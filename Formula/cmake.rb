class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.5/cmake-3.19.5.tar.gz"
  sha256 "c432296eb5dec6d71eae15d140f6297d63df44e9ffe3e453628d1dc8fc4201ce"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1658569ae8319c6cebd27b6b77bf8309c8b72e1af2e7fd353e4a6360d10d6910"
    sha256 cellar: :any_skip_relocation, big_sur:       "278f2ad1caf664019ff7b4a7fc5493999c06adf503637447af13a617d45cf484"
    sha256 cellar: :any_skip_relocation, catalina:      "c42d53380afdc00b76ec56a503fd6e27d8c64c65a6aa5dee0bebd45e35a78209"
    sha256 cellar: :any_skip_relocation, mojave:        "c4eac1fa4580a117a33f03cbd1ad8ccc5ec68770cc24bbe23bf9a3d55048ef70"
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
