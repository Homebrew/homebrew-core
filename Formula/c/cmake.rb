class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.5.0/cmake-4.5.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.5.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.5.0.tar.gz"
  sha256 "424352d6133e8455e020da787008e8dc67abb18820af3532572ab35657e49213"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d767a6fbc3ddd3af1776dfbeda0d16d5b00697ec4c6244e55a4069965a0da225"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "840a1c236fd7c7ea3b8754363866bb5e53153911b5cc50e32e951deb42efc5c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f70a117f6c44cb2133c8e349d910953d0f02f840b380cd3458e153b80419a8c"
    sha256 cellar: :any,                 arm64_linux:       "2a3dfbc4bed150b0ce80cf460c607c121c7e6aa029fee1494468d03b467a8b60"
    sha256 cellar: :any,                 x86_64_linux:      "ede8eaa9e36f2484a852280eedfec1dd5640045e45e3904a96a311c2e0dc2288"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

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
