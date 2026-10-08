class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/", browsed: "2026-09-28"
  url "https://gameoftrees.org/releases/portable/got-portable-0.129.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.129.tar.gz"
  sha256 "420f2e9be88b5e7de33b247f6ae21b918c113cceb2cb9a94b37a46d514f30a3e"
  license "ISC"
  revision 1

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_golden_gate: "de9efddadf064b836fce7364c0a3d36d990eb39f596855a518047968ffdd9f07"
    sha256 arm64_tahoe:       "146d9d10a5c535f1f29948653cf405c998ac80c4c5725c663e760fc1dc3806fd"
    sha256 arm64_sequoia:     "4c00dd25449830a5a2d66602e409a5f8d9bc59d34b8767afe9699d6ca0c874ba"
    sha256 arm64_linux:       "714f5c33f79fd7ff2fe005143f990376e59eacd8ad7edf58bd82038671c19425"
    sha256 x86_64_linux:      "a488a562a2971ba5e16459e4cfb6d6e5dadfae975b90de22dbdc71deeaa67676"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@4"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # `configure` hardcodes Homebrew's `openssl@3` paths on macOS
    inreplace "configure", "openssl@3", "openssl@4"

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
