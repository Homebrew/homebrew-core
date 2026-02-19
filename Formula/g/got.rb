class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.122.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.122.tar.gz"
  sha256 "1c3e9d5a5ff13d92184a8ae586f04e6a08a95902b41d512393ee1854cfe24018"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "2b6f63b1df02c572a41bce231cb621c4c1fae6ad8f463c4ba11c99289c5a375c"
    sha256 arm64_sequoia: "d59d5ffe51319b1e22f3c5b22b36f4ad825f2bcf2d12c6293b3f89ff2c3103f2"
    sha256 arm64_sonoma:  "d451248b496aae3edcba4b32f0b800dd281ed37c0f43f377c61367d5d4fe9fe4"
    sha256 sonoma:        "39c38f12fcd0ff4dd2663f4b84015a6031e92c3e8cbffe9be7093e64fa0d905b"
    sha256 arm64_linux:   "0c27cf25f7aeb054069b9e4124b29e815603cf63e6cd54c6aa21dd19765048f7"
    sha256 x86_64_linux:  "6ef2333cdaa2658fdaa6ac64ec89fdacf1e7039ff91e5d506a44714c32a118fa"
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
