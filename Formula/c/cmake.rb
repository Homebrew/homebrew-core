class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.2.0/cmake-4.2.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.2.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.2.0.tar.gz"
  sha256 "4104e94657d247c811cb29985405a360b78130b5d51e7f6daceb2447830bd579"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dc5a33b05816f8b9a1fcccb07c20976406e7353afc84065c56b3b04058dbbf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56af606ff0e0f76281f66379b41d229414f48645604d0ca91e1dd5310a0d5aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a774e8d54e3cf0de607a7a7ba79939d5a8a98b8b335a4929467f3a17a2873c"
    sha256 cellar: :any_skip_relocation, tahoe:         "f55f425356f6ddfae0a9318abac9eb9aa2e7a249af1428cc68b2611f04de8f71"
    sha256 cellar: :any_skip_relocation, sequoia:       "9e25c9253146bb0e48e84207c15b5c5cd3bd21db7159af98885478643b296bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecef21241e9c1486ee93ffaf09191212553a56b08134c04d266240890cf2dd2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bed21019f7b57667d9ae177502991c37b38cc15e2bd63e1a62a7048c0a3d7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6646594e3a32889a89f2ba39140bb0a5727d8e71283f8d7733dc95aa8adbd3b"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake-app"

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
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version.major_minor})
      find_package(Ruby)
    CMAKE
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
