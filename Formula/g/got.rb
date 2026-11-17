class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/", browsed: "2026-10-17"
  url "https://gameoftrees.org/releases/portable/got-portable-0.131.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.131.tar.gz"
  sha256 "7c0cde4201feaa398d1e9bf8a8bb697bb39b2dfba05a317d9fae20f1b19b51f1"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_golden_gate: "18ed15e709a657b822a170368243b626646d2face19be93ee8d3ae3d01c9a5da"
    sha256 arm64_tahoe:       "3262bc2f4c42b0798be68159df0a17262ed1592f805c4d0f2a47786d183a6e71"
    sha256 arm64_sequoia:     "4c3b090a1299ed33ac712921756957c1f1f83e9d8a0171fb8e484eb58a0d0f1b"
    sha256 arm64_linux:       "43c9d076380fe944f0488af60e57b92f9b7c9e37f8e0730243acfa98373f968a"
    sha256 x86_64_linux:      "da4ab981cdd8dfa282f3aa1f4bc862a7acacead89368f4e5b3bf90540858a1bc"
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
