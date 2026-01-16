class Cubelib < Formula
  desc "Performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.9/dist/cubelib-4.9.1.tar.gz"
  sha256 "d82a899af07ec6c34c88665a0dfddbbc33a760031b1a79f12d168301e8ea1e46"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "73757867db87cfd2200a7817d5c674dd4e41bd679b57fbbea666ec62f6dfd7c7"
    sha256 arm64_sequoia: "5678bf83522c7adb80932fc75aa4e163522ffa887eb95883d48d6f797c15495f"
    sha256 arm64_sonoma:  "6c692880220e40f0da2784a6e8fd6b0d034e8f13cb5df1d3e829ba5c9df9d9cb"
    sha256 sonoma:        "5eb3f583447141281e6f4aa4ccb230b14c61f24b5c577705a6a515ee258030d5"
    sha256 arm64_linux:   "0ff4fe882c0d1affe9aad2162de319779d15229ba65d06c99adf5ff8864f53a7"
    sha256 x86_64_linux:  "0319f610722cc9435d1a3063224af0825c2ef284d7a26dead2316e92c74ea62d"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
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

    system "./configure", *args, *std_configure_args
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
