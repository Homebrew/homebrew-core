class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2026.90.tar.bz2"
  sha256 "16be820347723271b0fea6049ffeed6d6680d7429c65406d8af37776393a0250"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b93c8a9cc403ae7057316aec8a4dee8d5f65f444d9a2a15fbff1abbd955d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db1455427cfd8629baec5dadf3a44424750eb27d687029aafc0d8fcf7dcb654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ffd597ad45bb26a9a6177c22819249d8f25084226f414e4a52537c0d65ba4f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "24b31b36714d665b3be64e469f2508999a88d2fa3c61dfc701a5bc86a91eb1c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb34b232f230a9da171fb4c8973c01e784f204dc0cbc362961401b6f926c9f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec110eda23ad96e37017a7d62938517ef6006479a5941cec10794cb16b6440f"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "master"

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
