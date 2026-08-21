class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2026.94.tar.bz2"
  sha256 "e098034a843699200c8c977a991fff73159735bf795d5f72ef672c41a6b1ae81"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aebafeea585eaf37df73f14f70cabaffec10d7b35b8a33a075b7797d9d1c4d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c655ef7967ea7865d6b790825910d7a9ffa263f31eae9214006158c7048e519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3548304854e3e00b4ba7905fada455fe60d16d829af309ebd6da4ee8d1f86cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d756c1c5f3e76f08e4c775495dd129deaac2e06c26c6b3543635033d22b2c91"
    sha256 cellar: :any,                 arm64_linux:   "907d1ea5d3510fbe3c81db2d54fb5936fd164a69f4ff81644f1ccfc4618e86ca"
    sha256 cellar: :any,                 x86_64_linux:  "b2f348574024850f30a8b9fa8f4d6e03ccba9659193735316c03b428dfd18141"
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
