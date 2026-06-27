class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2026.91.tar.bz2"
  sha256 "defa924475abf6bc1e74abc00173e46bfdc804bd47caafa14f5a4ef0cc76da34"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0574e887aef8405f44b744e9348278110a2573b62b32c92badcfbb1518f7a2c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25f09e049d6501adade2bbc8eaad1c3cb916884d6b9248dbff41d5f3f3d21f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443b916c0ae36b222862e311d2f2ce548189944e8e6f9ba882d4bc7b43578f5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69722339bda4deb18a2ff5424ec8457abee89911a7fceab66a5a1aa6cfb30d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd099e3a0a06460e46596e9c1bb4196c67c57c4ecf9931481d710295170f173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d125dd63b3d5b57d019c2a4e6b7a11e48222cdbb50b029c971c56b5020559d6"
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
