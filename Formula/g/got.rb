class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.126.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.126.tar.gz"
  sha256 "ad75dd883186af10a2f8ba25f5b4e6e9b2974d392f35c8e0a393b4ff134b482d"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "af262d81a1c3ff6d47329240cb1aaaea318be94c4d9492456262ab79f0fe58e2"
    sha256 arm64_sequoia: "9c395b8c84ac488348964e723655f81ee22e27a4779f965463a6ada5e67fe82c"
    sha256 arm64_sonoma:  "ecc70448c43d219f394dfaed855517660e186b8bd67ef65608c46f3c535bfe51"
    sha256 sonoma:        "3bca57f533a9ae47dc9cb3a8e5e101a427618e57e5fe0bbb7a9b30e26925f4cc"
    sha256 arm64_linux:   "6108ca5607dcdad03205c21e918999859dea0e44c00ca89d6db08ad70b65df0b"
    sha256 x86_64_linux:  "d4e6b6b6325cc54896b42567197bbd827db818b9e20e35a6f8a4ac11b214cea3"
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
