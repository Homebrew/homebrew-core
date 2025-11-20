class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.1.3/cmake-4.1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.3.tar.gz"
  sha256 "765879a53d178bf1e1509768de4c9a672dabaa20047a9f3809571558e783be88"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be88879cef605cbc4b53955fd9167055b6721f7f94bdbf63e9ea2d3edc11579c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f0dc305f5b84ef2bdae0093e46ca24a5cece5a3e4bf61654cb21267e84519f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fba92747c9fdce7c81dc4b09b3ced37bbd8b63f8a1e4ea3a42349753351066c"
    sha256 cellar: :any_skip_relocation, tahoe:         "989e147553c9acdecd1e5699c8a6d9c54a1acfccbaeb78cc76d4d37320aaf5b9"
    sha256 cellar: :any_skip_relocation, sequoia:       "8f7087d8fee4cfbee883f3a8936f986dea3e9d2c9135b76108e687abaf998184"
    sha256 cellar: :any_skip_relocation, sonoma:        "79da94b613b19e062a9a878d1da518d26e9274bdcdd061300746cbbea2a92e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8421d3607795cebe8774c2b0a36f4909dab690e45380187fa7733867e8e874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b096f5e6a601a7f3972fef34e123ff76c308f87de623f037a3f982f8a5e7298a"
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
