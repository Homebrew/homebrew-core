class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.7/dist/cubelib-4.7.tar.gz", using: :homebrew_curl
  sha256 "e44352c80a25a49b0fa0748792ccc9f1be31300a96c32de982b92477a8740938"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6b647d7c7673d0b4b95c7240dc477ee13e0fdd5c9f8952bd9b8d80b0f3f55d4d"
    sha256 big_sur:       "2680056fa693e78f9f89fcaa55b67888c4aa2d947cc4a2c9d2167e3380782517"
    sha256 catalina:      "5b03ba168b4d88c74b68409a9d7fc5b6aca796a78b7e55d29a1cba2d29e1595a"
    sha256 mojave:        "5eca16fc5e707d28e6595f070a49516d65a46aa495b95ab78616777027e36114"
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
