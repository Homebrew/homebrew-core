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
    sha256 arm64_golden_gate: "49269e5b1d502dc25a7743525bd260223866b5b5e2038fcd0b58532b144eb580"
    sha256 arm64_tahoe:       "ef50731d15ca33c66a2761ce426e7d716f6b16c17042bd0290e95d67dfc835df"
    sha256 arm64_sequoia:     "565570c61351ebbae99425aee7637857539688d37ad965cb388ff5924751da47"
    sha256 arm64_linux:       "5712f1d38b1409ca3350a855ad61d12beb7e36c76d7c90e0bcfac1a8a62ac4aa"
    sha256 x86_64_linux:      "147a9b9e5948fef80dc18879f9bdf56fe8ec1f1ba897bc63cd35e34b960d1a2c"
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
