class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.102.tar.gz"
  sha256 "aacb50ea664b09d60be6e41ab8cb7b9c694474f90f9de19fbb7e916da6e83777"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "757c40f133049926ab873b28914289223fb35d3b34b3c4100ad1652b1f8b60a8"
    sha256 arm64_ventura:  "e91f0404d8fe464784a97326b3baedbc1ebc603f4f1f5c7f4c46363f3a3a871b"
    sha256 arm64_monterey: "a0665098805431145384f1539c121a968a73208203fc96ab94eb82449b4636fc"
    sha256 sonoma:         "f833f6ebd778a8f880983b7ad76779b5994b0c25b7db3444bc77769381bbc279"
    sha256 ventura:        "e23a035d57374af218d282f9ffdb503dcd8399daf21cd63efcd5d3afa5f1a8f2"
    sha256 monterey:       "6870d334b7f7ca3c0e71b09db16a9a364ea6aaea81b8b762081821ec7bb5642b"
    sha256 x86_64_linux:   "9b491a300b40a8f4da8f91fc44228e0dcc9c34dd62eeb91531419e84803c045e"
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
