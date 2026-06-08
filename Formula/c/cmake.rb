class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.3/cmake-4.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.3.tar.gz"
  sha256 "cba4bb7a44edf2877bb6f059932896383babe435b3a8c3b5df48b4aa41c9bb85"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0909823cdc70cbd8a94d300f8333b6396e8af6fe81983b73bc72a0d74f0c527b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb95d1b27d9788954790f5d3dcce0cdc8a94493e2163339dbef32e471a53d023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ab3c3c06c91608a7b3c7eaa223295e398c04e0b045ca092a89ca8e35098e68"
    sha256 cellar: :any_skip_relocation, tahoe:         "46e7cb52876031c6c1234d8253d35c17234798e12324939062180bd60b141b07"
    sha256 cellar: :any_skip_relocation, sequoia:       "dd9f89f056c445c56d3fbcde192a3894a3d1789a414d604391d3be58a75b5a4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff9d40ef957251b74972689328d9dd3e8b0cd8b38d44eeee716166d72659c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079f4584b843acbd2643638051e205acba5530b40b82c33c133e844317552941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27aba0b8e0eaa2c41b3383c827c1ddf853c907e54150fb4a52bd81f24958b211"
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
