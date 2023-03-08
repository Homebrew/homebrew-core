class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.3.tar.gz"
  sha256 "cc995701d590ca6debc4245e9989939099ca52827dd46b5d3592f093afe1901c"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b84d2b9844ae326750b498d6143eba05ba90ba85e2413ff8bbba8df52b69cb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c795988bd14da5691a246221bbadff427ef2bdabe213a7f97ad5e69b3f8a39e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc74b5362b7fc2d4c51ba4ac5d0859bf0557ddeb4ac2a518522f31785af102f7"
    sha256 cellar: :any_skip_relocation, ventura:        "f502d6ccb79b82ec25b2f4222c15d29e31fb906325ea80609d0e829ead9080f2"
    sha256 cellar: :any_skip_relocation, monterey:       "e08c954dfd2cd60b1275370d6e5bbc569af9480fb70c224f4aec44306f04cef4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e98740a0ec57228faa96fbdeb0636c46577a9b5c5c803960513e9d16f4f0737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab7740bbe65b3c5fa816e986a347007c8608083862735ad990d1497779a7d82"
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
