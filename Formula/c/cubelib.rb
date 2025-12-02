class Cubelib < Formula
  desc "Performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.9/dist/cubelib-4.9.tar.gz"
  sha256 "a0658f5bf3f74bf7dcf465ab6e30476751ad07eb93618801bdcf190ba3029443"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "57795d60a4a4a37d27de29d8acd7470440e41227ea33692fc211b5526b7d91c0"
    sha256 arm64_sequoia: "066378b05ed9eb15c6bbf9202e641a932e72e5c4e24ed5071a8df8b95f36fbe3"
    sha256 arm64_sonoma:  "0e1252ac62492b97973bbd9194104d68094c7b0c2fe66238a009e7883b027ad1"
    sha256 arm64_ventura: "6db4378728b7fef0376f751dff698b109b1690cbbd8847ca2ed9d4dc5708c2c2"
    sha256 sonoma:        "3b34171b089bddc118864151d5f16a6f9fd7ecf2061530b43a5f3d2f92ac9bd5"
    sha256 ventura:       "6e8cee9a4b318d0bf9846d6ee66d82550f33188ea584415fc74f548a4ff0dee3"
    sha256 arm64_linux:   "680d72e8b1a84ed6e454e16a859fcc5be4438e265ed62637b8ad0e6c57117999"
    sha256 x86_64_linux:  "f23523ee48a74275d61f881645e96f3a1f37f18a8ca70570e2a915a62930f2dc"
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
