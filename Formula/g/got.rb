class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.105.tar.gz"
  sha256 "3173e360dcd06fa241bec31fc4df862843ffedf2b010605680680b0dfd5ca244"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "da4768474fd00f05275517a0f0bb663d9ecda6dd9dece290f2234ad3a3579de6"
    sha256 arm64_sonoma:  "fa74fa651dfa628ce422724cb81f634d626e6d3ee006ffdc4120f5e51500ee49"
    sha256 arm64_ventura: "19aadedbb59622c5d5ea7913e7fa10aa5781f3cdb0c67429b30695dbee80665b"
    sha256 sonoma:        "89dd65414030f0cf7d4e307d70beea20069d98575a244d120a93f6d80003023f"
    sha256 ventura:       "e6b57633c9df7a556aaf24759186d287e5c7e0437b640d1e8a3d562c6ee7b209"
    sha256 x86_64_linux:  "854a687fb918605ad6f6a9c76cdc8b5b529075052c2ce98a86060520f8870e3d"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
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
