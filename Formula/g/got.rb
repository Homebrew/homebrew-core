class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.128.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.128.tar.gz"
  sha256 "5d7eb6b29ea151dda1b6f4e1e1a6a9ef9cfd14336cc9f3236edfc30da8615872"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_golden_gate: "098d7d69b3cc966f7ad73ae75eca223d1260f26caad0c1301ebda410a5b4758c"
    sha256 arm64_tahoe:       "83c4cfb30db72cd4fe29b5911b59c5b52960990a3f02f4c88ab94128b58f00d8"
    sha256 arm64_sequoia:     "a68182023c7525180303c9e5760450f7ff8ab4c80c657a68319cad8ecaec1f28"
    sha256 arm64_sonoma:      "223d35af79309a5274dcfd421d6ed45bac906836c6a789ac70269a676b5f61c2"
    sha256 arm64_linux:       "92680ac1e4884e7b8d6346fbc864755be3d0ed82b3921b117dfd15c8d7304e8b"
    sha256 x86_64_linux:      "e1efeda7925b8a0d7b84ff1cbf507c1bac92c4ef620b1ac19ea0bd60834fd243"
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
    ENV["LIBTLS_CFLAGS"] = "-I#{formula_opt_include("libretls")}"
    ENV["LIBTLS_LIBS"] = "-L#{formula_opt_lib("libretls")} -ltls"
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
