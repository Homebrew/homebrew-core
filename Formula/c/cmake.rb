class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.30.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.30.2.tar.gz"
  sha256 "46074c781eccebc433e98f0bbfa265ca3fd4381f245ca3b140e7711531d60db2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1a7afbdd456ac8cd3de0f5a1bde0489961fcca116db12e14b0802a819c72cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb8759c9f5b8db32b1487beac082acaf8ac0d0dd79c121346492be73e1124d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b785dba3f141d1c086d9235e1eee2803eeef21f0e3984c933c581a75f889343"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dc4f5f01bc6583e86096d4d54d34bfd6ff913a1f0bffc1b13e5baf6056d04c2"
    sha256 cellar: :any_skip_relocation, ventura:        "9a7d063cc375b3e8e9f0ab847379b519556f67f1842223a91a7cb90f8dc560b1"
    sha256 cellar: :any_skip_relocation, monterey:       "55f487c399392c9214c541e061231b2493730776a6d68bbc97d33fa2673eeb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91022e707782ddf419534ee51150d126a67a62d274c18f3a870cd087b1c7263d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
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
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
