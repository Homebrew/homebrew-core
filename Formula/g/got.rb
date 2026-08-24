class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.127.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.127.tar.gz"
  sha256 "1fb061d61bd9a51409758d2811558b1d0a57df1d05c7bbf2dea48a1e2f55ca3e"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "27c0aec410a9060f757156b251b83fdbaaaa83c6101d59fce7068555b8f5722c"
    sha256 arm64_sequoia: "b7963de018ff39c88f28f20e6a7004dace9cf2789e529851578a7c9ce2c1a278"
    sha256 arm64_sonoma:  "49297a23fdc0d91902f727b174f99d6f0caf24a4a5b90df3b256428cc8b1f268"
    sha256 sonoma:        "a3509bf7a6913bc167d1b5e5012c2b5336dee7faa03e74ddcf3347a9d9e597f9"
    sha256 arm64_linux:   "886876a2e8777747a560f79699a011a2c50e1bb58cc4ed81cc6c202436959823"
    sha256 x86_64_linux:  "b97c481de2320322461d2e5bdd380d03950a36fde5b3db9882d59b925e2d3d0c"
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
