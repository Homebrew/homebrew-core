class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.2/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.2.tar.gz"
  sha256 "b0231eb39b3c3cabdc568c619df78208a7bd95ea10c9b2236d61218bac1b367d"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e2c5a1ae09a0e35a582305caba6f7ad47adfd35cc240d8b2e6c24a106fdbb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f1f9f6a2a1a73ddb23f85ab9e60b02822dbea67437e0e3263ccdbdbe119ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442706522c7aa99018512b41f43ef6b3886bd6adbabc91401450852f1540ed8a"
    sha256 cellar: :any_skip_relocation, tahoe:         "6c11190a4470cc8b813227670233c7073513090e83af6eb02e23f30c6e8e3f1b"
    sha256 cellar: :any_skip_relocation, sequoia:       "781e965f824e5aacf040171dbe3c93785810f21125f8f2d406b0951647d19ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb020c78c9eae496d086556ca1d729cd4815203ef1b545d77de73767553b041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b78b738d51bb50e489362ebfacc1c3f441980e153c81305cf2a03dd510a0edb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72afa4b97cce47ab0433bc2e59b474ee585ceb3f7e55cf34ee7805ce687ae3f8"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake-app"

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

    # Move ctest completion because of problems with macOS system bash 3
    (share/"bash-completion/completions").install bash_completion/"ctest"
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
