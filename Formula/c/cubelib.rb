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
    rebuild 1
    sha256 arm64_tahoe:   "af8563eab21f130a1c32ffebcbc1808975d166316d8ec5576a83dc2ebbc437c9"
    sha256 arm64_sequoia: "1ccf40f98502d79ffbd32bcff4ae6212b8b96aa525e60db0665848183139da9f"
    sha256 arm64_sonoma:  "09ebd4777ba76e31a2f4c41ee65144b9a797ee0d556278da43962164048fcfc9"
    sha256 sonoma:        "d4013dbc7bb8da8188a0d17d09c52ebc14f36db09df5516150fe2a39ee2599bd"
    sha256 arm64_linux:   "d9915686606c3dfa397292fdf87fec0a16af4407344ccacdadd10792a2542e45"
    sha256 x86_64_linux:  "09faef23e866883d28efac0afb0d96a72cb574c558ff16ffe1b047b842b50fa5"
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
