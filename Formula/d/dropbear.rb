class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2025.87.tar.bz2"
  sha256 "738b7f358547f0c64c3e1a56bbc5ef98d34d9ec6adf9ccdf01dc0bf2caa2bc8d"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dfc0dcddaa51ff418928bbab824cd4382635ba80ae30cdd90e666ea08a965b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4677b6768e3875db44518083f5ac557c17fc9fb964b12839677d0e6284d3f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35ef5691418b6927d65e7158ae999b21ee8ee6cbf01d5a6d3a92c44e5fd0836d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c1b9b713aed39530cc9ff87b499998293e601d10055bb037498cd9ae29f6dfd"
    sha256 cellar: :any_skip_relocation, ventura:       "150f8a1e98c529ed24a7e544772de85dcec36d853007938bf0e55a4802758585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930552145f7a020c1c9c78afce2f1dba87ebcb50de3477a42a5e187e6bf390d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea8c7093f3d411aea877bfc1d26c9538dcf3c6a973aa21696a34b2902e72b5c"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system bin/"dbclient", "-h"
    system bin/"dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_path_exists testfile
  end
end
