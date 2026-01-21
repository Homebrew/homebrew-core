class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2025.89.tar.bz2"
  sha256 "0d1f7ca711cfc336dc8a85e672cab9cfd8223a02fe2da0a4a7aeb58c9e113634"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3ca916274435c87b7e975fc93c3c6bc52079f56612a5df70cdc72bd1cccf4e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b2933a1daf1753acf72ddaf86e57e85e0f1061335e91115e580dcb9e1d34cea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "331c2e00bedc347194efb0317603608c28b0a89195fe72d73a18991498384853"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a0f8b1cde590b8eb3997ea37c13502b93d3733e27de46cafa83e8ee477b0f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb4bb13d27e88e4e00ae147a2ad72e1bb84ed7226c471c176e7b91195cd39b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88e50f72e63c90819735867d3c27aeff1658fc0418fd81e27facbb3cfff38a9"
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

    # It doesn't compile on macOS with these macros because of the missing `setresgid()` function
    # There's no option to disable it via `./configure` flags and upstream suggests to fix it
    # by changing `src/default_options.h` manually (see `CHANGES`)
    if OS.mac?
      inreplace "src/default_options.h" do |s|
        s.gsub! "#define DROPBEAR_SVR_DROP_PRIVS DROPBEAR_SVR_MULTIUSER", ""
        s.gsub! "#define DROPBEAR_SVR_LOCALSTREAMFWD 1", ""
      end
    end

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
