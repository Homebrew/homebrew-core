class Cubegui < Formula
  desc "Performance report explorer for Scalasca and Score-P"
  homepage "https://www.scalasca.org/scalasca/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.7/dist/cubegui-4.7.tar.gz"
  sha256 "103fe00fa9846685746ce56231f64d850764a87737dc0407c9d0a24037590f68"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cubegui[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "cubelib"
  depends_on "dbus"
  depends_on "qt@5"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-frontend"
  end

  def install
    ENV.deparallelize

    args = %w[--disable-silent-rules]
    args << "--with-qt=#{Formula["qt@5"].opt_prefix}/"
    if ENV.compiler == :clang
      args << "--with-nocross-compiler-suite=clang"
      args << "CXXFLAGS=-stdlib=libc++"
      args << "LDFLAGS=-stdlib=libc++"
    else
      args << "--with-nocross-compiler-suite=gcc"
    end
    spec = if OS.linux?
      "linux-g++"
    elsif ENV.compiler == :clang
      "macx-clang"
    else
      "macx-g++"
    end
    spec << "-arm64" if Hardware::CPU.arm?
    args << "--with-qt-specs=#{spec}"

    # CubeGUI configure only recognizes QT_CXX==g++
    inreplace "configure", "\"g++\")", "g++*)"

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    inreplace pkgshare/"cubegui.summary", "#{Superenv.shims_path}/", ""

    mkdir_p bash_completion
    ln_s bin/"cubegui-autocompletion.sh", bash_completion/"cube"
  end

  test do
    cp_r "#{share}/doc/cubegui/example/", testpath
    chdir "#{testpath}/example" do
      # build and run tests
      system "make", "-f", "Makefile.frontend", "run", "CUBE_EXAMPLES_DIR=#{testpath}/example/gui"
    end
  end
end
