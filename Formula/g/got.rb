class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.113.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.113.tar.gz"
  sha256 "29468a1b9a35fa2aba932807595bc00d010ac54192390468f75a0ad364c56f01"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "72f75655bf3683761b1f8ddeecba24afb3face058dfa202cb5ba6b31006b652a"
    sha256 arm64_sonoma:  "6fa522d7b0bcc89c697510b8150e10967543c686ec9cd6286e3d8f7da19026f9"
    sha256 arm64_ventura: "b18001240c484bb8f1e0f24167f90e40ae54b10996c420c5f965938e466ea6ad"
    sha256 sonoma:        "3f314d867ff6e0853e8592f4a9004c23c47dedb2a6b171c9013ddf8a9d01e0e4"
    sha256 ventura:       "d030d4c392b1193baab0c8d4a5e655d667946ca8c163dec0f205a1870eb41fe0"
    sha256 arm64_linux:   "95eee8ad7430d0d60d1c489d5273cbe030a3f629117d792a487b611768c88add"
    sha256 x86_64_linux:  "bbb1dd9920a21bb38167eb1f15aded62ccc85937c4e627d1840f7337e89076f4"
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
