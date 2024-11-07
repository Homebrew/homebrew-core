class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.0/cmake-3.31.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.0.tar.gz"
  sha256 "300b71db6d69dcc1ab7c5aae61cbc1aa2778a3e00cbd918bc720203e311468c3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8657731ef6748f043699a3f95ea6eccc8d27180e088871c3eec29d47273f1ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e0e20eae8e728544f4063aea9d959083285b25a951a5e3ff090818a1f98fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1077d6ba9f88e9c8aaaa73de9c7ea186e9095fe34946fccde333d639438403c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a0ea704d3af00a79fa96bffa6bb3f9d4794399537fc8d08db8c76fd1871c86f"
    sha256 cellar: :any_skip_relocation, ventura:       "524d914a598a9c3a82711ca2954a9576fd1074b6c7030c6d6bbd796c763e917e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a6df026fffd0d69dc53899fee231b969f8e8872063b76773d0ec975a24f09e"
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
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
