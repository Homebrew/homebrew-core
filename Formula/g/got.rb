class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.124.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.124.tar.gz"
  sha256 "8ff38e980a9343aec4152bb5ac1fc916ca093cf655c73a786fb8bd87a50d9c44"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "ce5cea46c5bab9bdd75db0ee7036a800634060d5136e64a36119d7a1d420de43"
    sha256 arm64_sequoia: "44bae8ab91c2020e93b4496c07e54ef225261cefe081d78bc981989a6c6167c4"
    sha256 arm64_sonoma:  "6b506a99b8bd77913d9a39d15c0925766c2e54c8bf7525ae828ed875bd2230cc"
    sha256 sonoma:        "82b6dd29814d6eeae016ea22dfad66d30136b0ed4ed420574a06898bb3978b78"
    sha256 arm64_linux:   "7ac4a3c91986df758546bbe1fdc3361411d0b15e75465530fa6bc584abede426"
    sha256 x86_64_linux:  "7ec08b52089f7648cc830321d3cbe21c085c89021d20f17c41256042171e55d9"
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
