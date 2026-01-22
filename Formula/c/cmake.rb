class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  stable do
    url "https://github.com/Kitware/CMake/releases/download/v4.2.1/cmake-4.2.1.tar.gz"
    mirror "http://fresh-center.net/linux/misc/cmake-4.2.1.tar.gz"
    mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.2.1.tar.gz"
    sha256 "414aacfac54ba0e78e64a018720b64ed6bfca14b587047b8b3489f407a14a070"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60d81644bd73a572793cbcd7a74c4cddbec34ee53ee09e24848d33afaaddb8eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e06a9009d98f940d2873e2e21cdaad13f622e8866f838991ed06fa44245424c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b4255c8eafdb8b0f4672a441f0ae6b91420a6a363569022f690aea1f39a531"
    sha256 cellar: :any_skip_relocation, tahoe:         "35e42f8d06ef0caed4c22be018b075c46a1cde0c45ed1b1b31875b6069f7c6bc"
    sha256 cellar: :any_skip_relocation, sequoia:       "2357e7be073335b1369b2e5201d5d2af3cceeb43bbe4fa97f8a3171359350242"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4cb6757bef63855fa0969e7f5507de92cd74d739e67cf3e9d40ae6938cb9183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657277ecb3da86ef8cbec1d8dd24e2a7fac9d805153634c1c328cafb386e16b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8704a4160e387e165b172089faa268727ab5bb43acc66f9fd6ade052d7d18e02"
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
