class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  stable do
    url "https://github.com/Kitware/CMake/releases/download/v4.2.3/cmake-4.2.3.tar.gz"
    mirror "http://fresh-center.net/linux/misc/cmake-4.2.3.tar.gz"
    mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.2.3.tar.gz"
    sha256 "7efaccde8c5a6b2968bad6ce0fe60e19b6e10701a12fce948c2bf79bac8a11e9"

    # Backport support for Lua 5.5
    patch do
      url "https://github.com/Kitware/CMake/commit/6347854fa279cda0682c72dffbb402a0ce29ba51.patch?full_index=1"
      sha256 "d0c0b08826fc16468dba8672f8a6b77c56062bead4c5c501360e868e511ee91e"
    end
  end

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec220979dcce6f31e51f2c91ea1add28d60f0a9607a61641f279115f27216035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3631ec91752e960abbad9049edd4effa34ce2a3eca969d03df843d3c6940d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e3122226b839098ac4981fc945b08dac5c43fd6e65ba02a1b96e774578914e"
    sha256 cellar: :any_skip_relocation, tahoe:         "a8c446217cb2b06087c0764a2de9f40fd3bd9c57163fdbb22fdee738c7545e50"
    sha256 cellar: :any_skip_relocation, sequoia:       "d84159c07d244bdb386459bf62c58d00e9f1f2425f98893883a4ee8f3e074a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc8034607d8d7c835debef687dfcf5c3fe316fd767fce86ca14979d81a221fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "139bf32b518db003c7a25f6f29e25e7371f3aa022605b5bb2e23a94074d9f425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b94ff7d2b35b1b560c7752d7ff6b634bd2911aa15f925609d0f0814a1b418a9"
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
