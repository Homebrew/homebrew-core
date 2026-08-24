class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.2/cmake-4.4.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.2.tar.gz"
  sha256 "1db9e61e60b6e0874c86386340b910382f3c5e75b9fbfb44d122063129a2789d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "207ce99392cf1560ad0ce1f3ca95d519645bbe7392a91321f37c2b8bfd9b8ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849459c1ae2f185635f814092754f5eef09c08015f4492c8dee5c2445dd8dd07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20ea982f3c380079ecff6d2e935e2a4a2d1d7c72387924fbffea62b828d5ddf1"
    sha256 cellar: :any_skip_relocation, tahoe:         "c3bc5d8d0304e0516fd728f0fed783cd6367284b66a61164a879a76d42ff52d6"
    sha256 cellar: :any_skip_relocation, sequoia:       "9ac37870e734dc6c3daacb3613443e0e7bdfcca941fa4fbe600669fcb5dbc6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e47932c1ef9a63c9cee792f5a1b04dacbb8d470ed199a8cc6eac1f73c58f0326"
    sha256 cellar: :any,                 arm64_linux:   "d2332ba81b8f966db5222fb6042339992ba477d15ea3c0633d7219d8a5a46406"
    sha256 cellar: :any,                 x86_64_linux:  "52c08b7c0b8448e8534e2f5c3e44b839bda607217f5f0b27e6254d0ad6d31278"
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
