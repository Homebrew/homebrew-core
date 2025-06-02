class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.2/cmake-4.0.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.2.tar.gz"
  sha256 "1c3a82c8ca7cf12e0b17178f9d0c32f7ac773bd5651a98fcfd80fbf4977f8d48"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd4605b03b0dbf10d547e2ffa34166acd8e77f8f76dac0485d5376715829130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd627884d0c2819a5c1c100ca7352247c40ca0bd811237139fb50606d78db23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4182d37a97d4c4979c9ad22ab7036faa4d965210b9285c0a20144be02578ee6"
    sha256 cellar: :any_skip_relocation, sequoia:       "91841ca89f8807fe911dfc60d8d72775119dfbe0c105fe4f4793fc59ec281954"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5999889dd5a97f189fd7ff78b9036cf60c10dc72905c7384f743722d214c460"
    sha256 cellar: :any_skip_relocation, ventura:       "5b5d12bb69a5bae6ea3ea7ddf0c7356db688959337cdb52f7bb66dc7ca2a1807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9248442ee82a1b3fac2e9b067b0bbe618e400c90947663e706d0d1a1a122133f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23429f1cc5f10a318bc8ad42eeb32396b09e0a4f56f28535eb06b606bbde987c"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake"

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :high_sierra

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
