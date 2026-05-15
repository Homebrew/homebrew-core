class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.125.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.125.tar.gz"
  sha256 "add61980107364372aeb81687bc58a66c0d0c9e0a2c4a9bbb6d3714fb452baac"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "7faa3e8a48268e37b1c1517a34f2dac757ee08675c5612d14d8cb4cf40021775"
    sha256 arm64_sequoia: "a207de936f380349643f69a121dc9611b06cd7eb786084b53ad9cb52258d086d"
    sha256 arm64_sonoma:  "09cd922085ea32ad3debe69480e4701f968f69bfcca75a3dcdfd1103da3d0b55"
    sha256 sonoma:        "66e4946b354d7612f20691728afece3f1ba37a228e35ea3fcb69fa94dfae4abd"
    sha256 arm64_linux:   "c8cf9c5c62d817b12d31adbaef4e63bf7412c7c87f94b16aabf4316f06d9e3d6"
    sha256 x86_64_linux:  "a9def351b3b65bca9e1bf3bcbaefc0c15aea86533830ffe2c5986fe1ad91ce00"
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
