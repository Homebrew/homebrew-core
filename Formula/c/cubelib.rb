class Cubelib < Formula
  desc "Performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/cube/"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.10/dist/cubelib-4.10.tar.gz"
  sha256 "ebdee61f2da04886430c4f8991fc1ef336c63a5409d122f71ccf1910851d0d4c"
  license "BSD-3-Clause"

  livecheck do
    url "https://scalasca.org/cube/download/"
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "1e2317063c8c1bb119c4b41246876cbd27d6e7927f993dfe197c5004e015b880"
    sha256 arm64_golden_gate: "98424689be5e74ab970aa89dfa71e6db7092abcc4d80a1c3094e35122f1e1b0c"
    sha256 arm64_tahoe:       "930efb74e7ee6cc1045a248abe572fee6dbcd2168509ebf54dfd310de5af0c93"
    sha256 arm64_sequoia:     "fe7f7490fdb9221337b2f25629ebd209d0e6d854cace9555370c40bf9d345ea9"
    sha256 arm64_linux:       "df85f2b5cd986d87ecdcd47f710e7507ea634582a1d3d40fae54ad4ccf4f6f1a"
    sha256 x86_64_linux:      "377c239b0a1edace48f9e722831286851bae0bc0b0450e7f0f3826db38de0438"
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    directory "build-frontend"
  end

  deny_network_access!

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
