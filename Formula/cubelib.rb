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
    sha256 arm64_monterey: "089fedf98faa3718a4785ebbb7293788c243da97ec90d19f59e3e9d9ef9d1794"
    sha256 arm64_big_sur:  "dea38e7b971f6224476d825f238cdf99f67939a1192cfbaf9002094790966c61"
    sha256 monterey:       "851901171cd00b0b7264cea204192fa401e1ae9dce6ad7426488311a30894dc9"
    sha256 big_sur:        "00e9988c22abb19f792c0bdb0e69741d1fd549e43152b147893b3089b619d86e"
    sha256 catalina:       "7f8d1c44c47f570ae9ccd97b674452320861393a7c745f4770cf5a0bfd43a366"
    sha256 x86_64_linux:   "85204c024889a2bba352c8df5864ef8d38c568219b4b22d10c89face9131d855"
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
