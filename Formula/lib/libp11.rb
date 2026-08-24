class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.20/libp11-0.4.20.tar.gz"
  sha256 "a125e0310ff10c189fc1b32a9652101486ea94a6b07c677a30e90e3638d2db48"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10175d4baeb75330bee16b8903ec5e88d5b991b9da43f2fbaec1be4077a0fad4"
    sha256 cellar: :any, arm64_sequoia: "3bc52a04b32df16febc63738a8fa2e5552bf6f74afe5eec2159b6d91d419a957"
    sha256 cellar: :any, arm64_sonoma:  "301a340e8e298abbd358ced80923695b5f1a0c8a0ab7d9148d339a51e456db07"
    sha256 cellar: :any, sonoma:        "c0df4bc1a6103b39338862eae2b7b1dade6f949abcb4bc3716f676c1f528b0e8"
    sha256 cellar: :any, arm64_linux:   "fcf6e88dcc5b19a454442954c1f9138d449e5584575ebd88cae705f356dfe900"
    sha256 cellar: :any, x86_64_linux:  "d27b58ba98f3ffd7876c6a32e4003588202c389d9ec8d616e213b58b6d7ab44e"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkgconf", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    modulesdir = Utils.safe_popen_read("pkgconf", "--variable=modulesdir", "libcrypto").chomp
    modulesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}",
                          "--with-modulesdir=#{modulesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
