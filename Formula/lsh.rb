class Lsh < Formula
  desc "GNU implementation of the Secure Shell (SSH) protocols"
  homepage "https://www.lysator.liu.se/~nisse/lsh/"
  url "https://ftp.gnu.org/gnu/lsh/lsh-2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/lsh/lsh-2.1.tar.gz"
  sha256 "8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3"
  revision 1

  bottle do
    sha256 "2db1726494a9ff362a3fd9644e6a966b9762ea62f921ecc217c5ca842f67864c" => :high_sierra
    sha256 "ec3239a890387f33979336941411a1fb9c26696ecaf1f3edd519c89b3f63f848" => :sierra
    sha256 "0fdcabfd979222e6156220f78077e404da9e43b4ce958c606b6b7bd52bb612d4" => :el_capitan
    sha256 "7250d308a5d19b50d44ff99c1863aac5e8123ca0733bfadd2c57c702a294cef7" => :yosemite
    sha256 "1ee5aa4a3fde1b0a5bbb30f31fed756b7de931f0ff39f559070d9eb02380e955" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"
  depends_on "nettle"

  resource "liboop" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
    sha256 "34d83c6e0f09ee15cb2bc3131e219747c3b612bb57cf7d25318ab90da9a2d97c"
  end

  # Start: Patches for nettle 3.1 support
  # This patch set can be removed on release of lsh v2.2
  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/0c197c83fa04bc99629520ba47c9f757e9ffd5a4.diff"
    sha256 "3ce6d9184899e9ece4d1a1be945a1055a3c2bc39df3852e38b224e78479d2c91"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/b782b3abcf3b74d7b6bc0a89de988e1866e9a1a2.diff"
    sha256 "70198d5e9f0f0c4235dfa036aef68699b6c29ceeac693fe24c5b2f9b2e36e4d5"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/faf69a2890e5457b3bd4c2efe8d52ae0f00c2562.diff"
    sha256 "4431eaeeaa8f6c3b34a82b23668e154175b105f8540a2c62124a7f32987cd1fa"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/dfe2b20109ffacef2b58fa530db820ecf34892b3.diff"
    sha256 "e3e9fc387c64b89765b104de8094c86cbd15343eb778a513716dbf69b0d91aa7"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/9849e9c2b77624f078c164f7cc15f51e586587b4.diff"
    sha256 "4afb53901d6ff74dff77ea0452d119125e491d05592879c9aea14b9fcf78b635"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/2ecdd4f40399eda862ed57a5d6c6ed0bb0eeccb4.diff"
    sha256 "3239f109484a806e6d99b78b47541bf1c7a984535916fbebadb34ea8a2a0045c"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/6d5f1995f9c3439ca7f608eca680e3248df9790a.diff"
    sha256 "1ef582e377e1be3c09895dc34654ab2d5543babbef4a2b2065ce2b8e93c42e83"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/32fc8525ee4828e49859ae2822a2bdc0a5901398.diff"
    sha256 "f852b52d29eac5cfa650681876570a0601cfc61d0e6c896797a57e4e151943e6"
  end
  # END: Patches for nettle 3.1 support

  def install
    resource("liboop").stage do
      system "./configure", "--prefix=#{libexec}/liboop", "--disable-dependency-tracking",
                            "--without-tcl", "--without-readline", "--without-glib"
      system "make", "install"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-x
    ]

    # Find the sandboxed liboop.
    ENV.append "LDFLAGS", "-L#{libexec}/liboop/lib"
    # Compile fails without passing gnu89.
    ENV.append_to_cflags "-I#{libexec}/liboop/include -std=gnu89"

    system "autoreconf", "-i"
    system "./configure", *args
    system "make", "install"
    # To avoid bumping into Homebrew/Dupes' OpenSSH:
    rm "#{man8}/sftp-server.8"
  end

  test do
    system "#{bin}/lsh", "--list-algorithms"
  end
end
