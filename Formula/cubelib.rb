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
    sha256                               arm64_ventura:  "31a4f63d6b368da9050d8f891619e9e62ea7cfe02af66f7004f12fd15bad6e04"
    sha256                               arm64_monterey: "0f32c63323cb7075849dbbff312a856cd54b8e6b8854a77690f7f44f63eb5deb"
    sha256                               arm64_big_sur:  "3b65fcd3200db9f61e8982b413f7f786cdfb3c40d2109947b83f4dd4afef842d"
    sha256                               ventura:        "f6c2ff0ca670e0446d95633e33d0f781ca99a0fa7fafa9af2d12104ce09e3506"
    sha256                               monterey:       "cb0b173a4a34539a1ba532bdd9d79ed4a9fcb989f48a3f12dd36af988822fb15"
    sha256                               big_sur:        "2e10383644ad9a107aeb3349c59d92e56db6f16b5aad086deafd5864c4c6ccf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c70544de82a4f24b4e7976141e63f16ae76b5e44ecd42a1ec0ed6077fe3b55"
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
