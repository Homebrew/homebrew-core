class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.12/libp11-0.4.12.tar.gz"
  sha256 "1e1a2533b3fcc45fde4da64c9c00261b1047f14c3f911377ebd1b147b3321cfd"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "11713444dbf087edd87fc04858797938ec4d4fada46c4c3eac7e7dc6d0ac891b"
    sha256 cellar: :any,                 arm64_monterey: "b5b73420ecd69a357cc8592e118adb85e2071d689fa7b9d45578051b0b05d18b"
    sha256 cellar: :any,                 arm64_big_sur:  "17e248e27821ac929a5e8d13d6b5e70dafa8106987cb867cd8e7c02ed8b6385f"
    sha256 cellar: :any,                 ventura:        "47298110be110bd8bb81e720725b3afaf470a3cb5aed809b7f253bcf3d0c2118"
    sha256 cellar: :any,                 monterey:       "e34a9f8f5e18a7729b6970e14b421e203015dc576e9eab187a7142575e7a670e"
    sha256 cellar: :any,                 big_sur:        "8fd62e64790b4eeb4d706f25c1a0d5760e852908f603478032553101002968b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48fcd4d18d7fb24d1adba6b902a102ad0de908b6f1e007eb7d07a8ab123ef3af"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkg-config", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}"
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
