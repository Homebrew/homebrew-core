class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.111.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.111.tar.gz"
  sha256 "d096f76e91a700dd0d22fbaf9641c2b94f8a6de16f09b0f4939c9b96a9d878ce"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "68c85a42020eab8fc3d8c682ac925ca722972404198b2c7129fd8bc15301a82a"
    sha256 arm64_sonoma:  "197a48d590f8151bc84c29c1eddc44ec3e093df6f34ef43f5cae7d2d9c9167de"
    sha256 arm64_ventura: "89586da487f0f879033b928ddd73a8fa6f53d64b1f11f491c8a8803a48620c6f"
    sha256 sonoma:        "3f4cd4125196482e709e44dc99dd774c794b187049b0f796f4f705a95d3cd246"
    sha256 ventura:       "3df41972ed98834ef6c38086991aec8f9f38c8709c3a4e1cedcd0963f7850545"
    sha256 arm64_linux:   "4038503c0a1b9dd1d34c868cd1d3da6383f26b9cb0fdb645073b59491a75d039"
    sha256 x86_64_linux:  "e07cba7746ca57fa40d78a2df34c9f100d9d18c79637f16d5968ed3e65c68093"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
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
