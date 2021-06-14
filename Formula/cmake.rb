class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.4/cmake-3.20.4.tar.gz"
  sha256 "87a4060298f2c6bb09d479de1400bc78195a5b55a65622a7dceeb3d1090a1b16"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64f8e3f962dc5b74a6471b2b5b0b611d70113c917cebc12f2572fe134d168f9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e806457c3ff9a57e939ee86cbb2616c968a2b000cb0f320dc9de67d699b86041"
    sha256 cellar: :any_skip_relocation, catalina:      "646e7799e343ca9e16c26b618be048ab5b818705ceb60bf2a4267e22bd7435b7"
    sha256 cellar: :any_skip_relocation, mojave:        "963722b43200f18bf94d34c786d6de06ee94190b4704bf5d95fac6dd49fd9221"
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
