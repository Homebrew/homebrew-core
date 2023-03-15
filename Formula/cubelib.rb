class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.8/dist/cubelib-4.8.1.tar.gz", using: :homebrew_curl
  sha256 "e4d974248963edab48c5d0fc5831146d391b0ae4632cccafe840bf5f12cd80a9"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "880cffe3e891991564c8382a55a2a60980c9c20dbb9763bbb9e9977f46577ef6"
    sha256                               arm64_monterey: "0290c8ce0977fd0a9fca00898a79a0fd4182cab21ed26e0269b5395dcf73525f"
    sha256                               arm64_big_sur:  "746d7cf5118c9b8b1cbf2536bf6406ee947417cd1e55eb8b56e3e96f9a1a3af4"
    sha256                               ventura:        "458cc03b406c3f50445a34fb4edb07831b0c3860d74dc61911f964c58e29af65"
    sha256                               monterey:       "6d5ff9657b95c6615ce0a9b3190cd2bf1050cf8cb37dc8385fb27e19e347bb48"
    sha256                               big_sur:        "9ed456dbf250cbbeb5d9010fa60a8765db661bcf95efb3318e2af2642ecbcd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f099c06f1ca0fa821477e13f8efb89dd6606e78402f91cb6b62a008dbc275b"
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
