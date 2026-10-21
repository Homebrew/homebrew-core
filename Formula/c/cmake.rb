class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.4/cmake-4.4.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.4.tar.gz"
  sha256 "bd24c30d80a7744ae84b845ff080cc8453b06c622ef01066564108e9cefc44cf"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6614033037dd78df8ef4fea463235b7a463f92caba61fc9fc93214fcd948cbe4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30efb5adfba2b7441a0fd6980039fadba94aff6ee1052a383dad9fab9b078eeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2a7da6b1f351024c84fe36af692f31a196cb21be74dae8a3f36925467fa676b"
    sha256 cellar: :any,                 arm64_linux:       "0ed7f678a53d9f729dbf80444ecb56769da1e232e642b9e803c9ef8b4352cb3d"
    sha256 cellar: :any,                 x86_64_linux:      "103c3634b5e6027b19bcf41100bbe02b0146a68aa88d563ec296afcba206c46e"
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
