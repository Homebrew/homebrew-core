class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/", browsed: "2026-10-17"
  url "https://gameoftrees.org/releases/portable/got-portable-0.130.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.130.tar.gz"
  sha256 "938307dead3d2f4c11e424e996821cea976dd6de494815721447501944bd251c"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_golden_gate: "8bdefe62a5b500208001b2bc294831f52a954f2fbe4adf3ada4dd17eb1efcfc9"
    sha256 arm64_tahoe:       "4c7b58713ae09e6edcc003c3d1ed9327e57e527308195d151cc9cc47f8bd973b"
    sha256 arm64_sequoia:     "1f721d603ca50dc77bc551e07f3bb6775395ffcc0a1ed39782fb9f4aaaf5f7d5"
    sha256 arm64_linux:       "4677d6ea56c5c4fbbb0986eed3730855481c3ca28796a6a74700de0adb2fd212"
    sha256 x86_64_linux:      "3a32ebf40e7fce0a82621ee0b0dac8609f9e6593560e11f5cfe9b4a67c176855"
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
