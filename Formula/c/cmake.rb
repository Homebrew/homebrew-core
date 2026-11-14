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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23f036b5ff4bffe8ff1ab4d511f41897ae0b4706b65296474a2714d1fa013b71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "497c6366207d61a93ee3be3576250bfea8cc08e77f67666c0e5e2a0f6e50d80a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7db80e1f065cb99db30eba9751a4bcd225d35998be89e0031ebbd7e1733640b"
    sha256 cellar: :any,                 arm64_linux:       "466d35874352813b902f545dd9d5a26caaef07d000038c3d60c11c221c7561b7"
    sha256 cellar: :any,                 x86_64_linux:      "5ff241b01cd53cf9c96ff60c422a8e61519d704e2516d3455012c8a935022467"
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
