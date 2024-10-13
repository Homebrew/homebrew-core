class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.8/dist/cubelib-4.8.2.tar.gz", using: :homebrew_curl
  sha256 "d6fdef57b1bc9594f1450ba46cf08f431dd0d4ae595c47e2f3454e17e4ae74f4"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "a75f38bf5b5d38ddccdee16c72c4a3612edd497933e5f05c4cbb212ac60644d2"
    sha256                               arm64_sonoma:   "2b11087f52488b50b2828f240d8ab658c30c92aa29512b59d8b18dfe3366df43"
    sha256                               arm64_ventura:  "1d811d0574291b83062360b03a449d381dac2b229296bea739f33aeb1a17edfb"
    sha256                               arm64_monterey: "aadd710f61fc65f005f5e07ba91eebd5b4d7c91d47779b0fde316b9eeeb36992"
    sha256                               arm64_big_sur:  "323e03f8439b4fb0250fbb0016bf7950ab3816a7a9cf8b47c1ab29a5c2d42c86"
    sha256                               sonoma:         "44e70a9911bebf2ecac7827c87c1107d497fd2d791cf61e65f30d310dc741da3"
    sha256                               ventura:        "fe41d2cf6093309fc12bb5564e7cbb6b641451aec92956f3d89920e5cd6bc441"
    sha256                               monterey:       "9dc98f1eaa021114b31615d0c9b804cea0755d7c839f1dd7a0df2889ca2d2131"
    sha256                               big_sur:        "d66981b620159dd57d48bb0c45240dc6cf37085acdf288d9c5500ff07bc828ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305d53e0974ea15cf0e27a487bf1383eec50e7e2bf03f54e82c2d2c1654f57e0"
  end

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-frontend"
  end

  def install
    ENV.deparallelize

    args = %w[--disable-silent-rules]
    if ENV.compiler == :clang
      args << "--with-nocross-compiler-suite=clang"
      args << "CXXFLAGS=-stdlib=libc++"
      args << "LDFLAGS=-stdlib=libc++"
    end

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    inreplace pkgshare/"cubelib.summary", "#{Superenv.shims_path}/", ""
  end

  test do
    cp_r "#{share}/doc/cubelib/example/", testpath
    chdir "#{testpath}/example" do
      # build and run tests
      system "make", "-f", "Makefile.frontend", "all"
      system "make", "-f", "Makefile.frontend", "run"
    end
  end
end
