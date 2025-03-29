class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.0/cmake-4.0.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.0.tar.gz"
  sha256 "ddc54ad63b87e153cf50be450a6580f1b17b4881de8941da963ff56991a4083b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "755552ccd83c7342624996860b9f18b08b02c5f722ba6ddfb7eed167a9748c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3c640a30ae5aa8f083956aeda589e07b3c0ee4e3c1a0e8ad8d35a64add4367"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c5d06776a711a2113344e8936e524b5b45c2bce54494a25dc8cc79a107a497"
    sha256 cellar: :any_skip_relocation, sequoia:       "d269c0d7f1aec83dbb11888a05858b3000a32a0f692ee6a9e5857ec63ab078b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e93d4eba2852f295d041870b5b09b3b2b623debc05401fa7d4258ca5f9ef4a"
    sha256 cellar: :any_skip_relocation, ventura:       "25245623b0a79c06783a9fb289821d0d26fba4d7a0b7821dd49d420eade9c872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f70b75f2cb7a0e3ab8fc134b8cc4cf791749e5d34d514f6271875f821e93a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08ed01c567884c35fb3950bc82261f3fd968c372e5c63bf9136b1a928ef70e0"
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
