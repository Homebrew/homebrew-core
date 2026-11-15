class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/", browsed: "2026-10-17"
  url "https://gameoftrees.org/releases/portable/got-portable-0.130.1.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.130.1.tar.gz"
  sha256 "43c5fba2f3791e3cef202803baa819fd29c53c4ba1f89f90582e06c6a443beb4"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_golden_gate: "458b9bf4825f5630e5329182af66f6bf54d2f4c591b7d614d3982eea475996cf"
    sha256 arm64_tahoe:       "56d7c6f4eb7bc370989d31b13289b65a04ee25e8e66d0a4bbb98b5b8babbe3d2"
    sha256 arm64_sequoia:     "8febc62458cd9c4c9c48ff55fd04635dc4bc97f26fa7806888b0a1f8c5f5e439"
    sha256 arm64_linux:       "7614e7a2ad97dfe241658f7b7d5f50de07d96fdc880310b24d7d77ea27f99277"
    sha256 x86_64_linux:      "5d9ce5c85b50b973280a38b34787a82f1df188714cb4c54da6c632bec722a0dd"
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
