class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.107.tar.gz"
  sha256 "3f5851d84ba28450e5d97d080e86deb3ee68786de8c85d2d080d44f3cfab6a27"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a6482c220dc3d2eb27ad1bd437aeb0cdbc67940313814d86e51997367491eaee"
    sha256 arm64_sonoma:  "749691879e9cff2d9e1576f2981e235f90205d4172cb9cc0e5af4b996a179be7"
    sha256 arm64_ventura: "c3209ab3c7b06e006134e71933ba01cf94ceca3dd1bd918ad98a28594d76efeb"
    sha256 sonoma:        "c47737991b231857a8c72ed2ccd55507042cd17ae7d1ae94aa790ee38f0816d2"
    sha256 ventura:       "1fba479310a352cf7db88dc3fb8119340e287f97cac473b013a8a6afdb1d6a19"
    sha256 x86_64_linux:  "755e9a3ba122e548d79777db1753229f88f75ae0c00adaa1087f1c12786d2c11"
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
