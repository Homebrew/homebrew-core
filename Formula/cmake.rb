class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1.tar.gz"
  sha256 "fac3915171d4dff25913975d712f76e69aef44bf738ba7b976793a458b4cfed4"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36d8efbf810ad078aa05f2dc8a9de08ac98e489560c77c6f1b673a3f1bf8a4fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "9894cc5bc00c7b9b94028f76bd2365ade3ab1d992317b72d1d7a5363a6ba9024"
    sha256 cellar: :any_skip_relocation, catalina:      "284a8f5addce150f624b96b66a230780eb119cdc0f82fcaba9625a5b0d171073"
    sha256 cellar: :any_skip_relocation, mojave:        "e21bef39787a34e881d18cb5381bbdb775bb357a166aa7e15ab22a7c3d59517c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e325510e37e74ca83ea4ecc2276aaf6d66c6caa0eddb2a10d9055db0f1569f3e"
  end

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
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
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
