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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f5b19e4558fa37afa2c3c3a3deeefaf8d425ccd23a269a7e85fffbd8fa580ce9"
    sha256 cellar: :any, arm64_tahoe:       "b0af52e43f671ff8da921e1a1190afe177bca853d0acfd93b524d8485b42e365"
    sha256 cellar: :any, arm64_sequoia:     "0100187fd64dd40d62334fd6f913a7f5f30e81d1ff2cbe00801e3da4ac1cd8c5"
    sha256 cellar: :any, arm64_linux:       "520d4087824a06ade4605034c6ae5f8cc93fbccc4318ee44e486778b8a5621f2"
    sha256 cellar: :any, x86_64_linux:      "c1bd3fc9862f17eebfe3795270a9eef0021e166c2e329c64db8b953c8d170d18"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@4"

  deny_network_access!

  def install
    pkgconf_options = ["--define-variable=prefix=#{prefix}", "--variable=modulesdir"]
    modulesdir = Utils.safe_popen_read("pkgconf", *pkgconf_options, "libcrypto").chomp

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-modulesdir=#{modulesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    openssl = "openssl@4"
    system ENV.cc, pkgshare/"auth.c", "-I#{formula_opt_include(openssl)}",
                   "-L#{lib}", "-L#{formula_opt_lib(openssl)}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
