class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.123.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.123.tar.gz"
  sha256 "53ae795f03e2ee4f4696bf85768a9a7d64a473f20622fcc8508fa246cc288526"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "42153eec1c0cdd6a97f3fcfa9844379169310d69662f573e3bc3620391ac1f79"
    sha256 arm64_sequoia: "94acc8884c6e8843c24552969c5e4ee95be069e215500317b6ed942413d7e080"
    sha256 arm64_sonoma:  "82666d475d8b4434acfa4ad6323e4ee4d5e1c8de1fe1a7a907d53eb0f37b4d3f"
    sha256 sonoma:        "0e1653964d8b02c503ddda3faa78fa9a0751533497cab54528618526f01babb0"
    sha256 arm64_linux:   "b7be5020527e8afca69dfd0de84519588af0f3004dea3aa6d79fa9271ff61d61"
    sha256 x86_64_linux:  "8d5f523e7be43f222443c7e5ca66aa51434480c8329f1665db9bde32db061b78"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@3"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBTLS_CFLAGS"] = "-I#{Formula["libretls"].opt_include}"
    ENV["LIBTLS_LIBS"] = "-L#{Formula["libretls"].opt_lib} -ltls"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end
