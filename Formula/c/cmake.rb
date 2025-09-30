class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.1.1/cmake-4.1.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.1.tar.gz"
  sha256 "b29f6f19733aa224b7763507a108a427ed48c688e1faf22b29c44e1c30549282"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35b936843d26201af2b499ad5507596d11ff4b61bedb4ba22580a6be80afdf0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15af42c171e6914039f7188154145d20484a565bb43b308be9efbdcc893884af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b6b5cb55a60137a94014ff1f0e98848c2826b80bc702b32526646b23e31e26a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afa66498af1f31e12b55a94f1b786fc605bf917dd81a31a89ad6ed912548132f"
    sha256 cellar: :any_skip_relocation, tahoe:         "70adc28e06bcf933d8b4bf21c3801383b0f82393c204c8e8726e61a1ec8a6e45"
    sha256 cellar: :any_skip_relocation, sequoia:       "f95d6553376b9c884231ea983dbfe84b5fc52235d4bc6bcd04d7b021f350f248"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d655618f8b73b081f2d0a5ae0751217602afc46dc6f3327f7d05c0dbdb66b1"
    sha256 cellar: :any_skip_relocation, ventura:       "f1690bc671690a62165cf3bff9ee537b538c90fb8ba61d36a62ed373ca043399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c3586cd31b5945c9a56b37af0935a7cccd489ad2bc02db8b6de2aa1651588d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1125e00f1b7e34f0e63c96360ab43a2e459c79b352ab2228ffdd0296b5cfbe4a"
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
