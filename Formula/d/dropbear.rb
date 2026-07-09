class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2026.92.tar.bz2"
  sha256 "91dcb5234de8dea68dd82c55411c9fc986b457ab58372a780ee8a870419c2f7e"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed233d09f69c85d80b60fc056236404e10170afdf7c7d566f00b4a4bf98b67cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8727701e3582cfadf24726911f49e3a9a9cb62dc55af7598fac344f2133c2166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136be412e2a3af5587d799c1b7392866b464421accc0f221ac5a4b0e6e9a1f33"
    sha256 cellar: :any_skip_relocation, sonoma:        "245e357211e25b609180096b6d7eece4dc7192db4b6f05ae24e303abac46d773"
    sha256 cellar: :any,                 arm64_linux:   "b7377df0fb318599f7303628f55283ff0f2c9ee2af1df2f1ade1603bdaeb3e49"
    sha256 cellar: :any,                 x86_64_linux:  "107b2e19b03b7df8b022f11ac320fe7ec521e27a3b10ead374314b2db7e6f1f0"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize

    # It doesn't compile on macOS with these macros because of the missing `setresgid()` function
    # There's no option to disable it via `./configure` flags and upstream suggests to fix it
    # by changing `src/default_options.h` manually (see `CHANGES`)
    if OS.mac?
      inreplace "src/default_options.h" do |s|
        s.gsub! "#define DROPBEAR_SVR_DROP_PRIVS DROPBEAR_SVR_MULTIUSER",
                "#define DROPBEAR_SVR_DROP_PRIVS 0"
        s.gsub! "#define DROPBEAR_SVR_LOCALSTREAMFWD 1",
                "#define DROPBEAR_SVR_LOCALSTREAMFWD 0"
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
