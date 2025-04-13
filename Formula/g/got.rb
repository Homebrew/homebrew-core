class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.110.tar.gz"
  sha256 "3635e41205e7f85236a6e76ff785d3d8997131cf353c8cdf6f6d25c031661d29"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "82ef2a7a47e398660845915472ef97653ee95405c482bfd93e639513e9fb6e2b"
    sha256 arm64_sonoma:  "7b89f14411835cd97f75ad9a06f9334888be76f91624b8fdf2f9e8e27fb00830"
    sha256 arm64_ventura: "91e5fd638d9761501212812128043b319d6c8b951b9710015142df991ac08218"
    sha256 sonoma:        "ec0478c322a410ea10aee3ab2b915b895ae4319dd22f6735404c48279d808956"
    sha256 ventura:       "271338072b0c95c9b218344b4aa221460d86e58f5e0588fc19c953801d8066bf"
    sha256 arm64_linux:   "d856bcc46e0eb4e5424f6a1c2e2c379d3fbbe15a3518eb8b3a76b84149b4ccb1"
    sha256 x86_64_linux:  "285160cfbe66c9ffe5711ceb82b9dcb39d1786c7a7f403079424ec301fd41568"
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
