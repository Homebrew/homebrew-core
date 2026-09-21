class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.21/libp11-0.4.21.tar.gz"
  sha256 "efdb523aef8613d447e6a2d38227d4b389866f4bcf4b503130acd7f759490847"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3a3d8c0562e26805ff3044941a6f9f08571dd2f9b860069177daa789854ff503"
    sha256 cellar: :any, arm64_tahoe:       "0a4c68939012e96b0a0a90ee8ab45d8250a31034b04a88f2f9e11cf97512e283"
    sha256 cellar: :any, arm64_sequoia:     "f34dbb71ec65bf6efbbea04f315bb78dcd0fbdf415290475e293e78c1163dd9a"
    sha256 cellar: :any, arm64_sonoma:      "3ade95480d16f681cbf20bb11b57fa1ed50def7d832c3c368916e4270c3c5b9f"
    sha256 cellar: :any, arm64_linux:       "dc49f2a295a4a8650c7d4523eb041c81a31cd0dea9abae72a74791e3d6c3b77a"
    sha256 cellar: :any, x86_64_linux:      "9296e49c72bfb784ae401a8b1cdc1e76616844583df03774a7c2978ce9944198"
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
    system ENV.cc, pkgshare/"auth.c", "-I#{formula_opt_include("openssl@3")}",
                   "-L#{lib}", "-L#{formula_opt_lib("openssl@3")}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
