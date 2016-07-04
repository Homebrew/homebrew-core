class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  revision 1

  head "https://github.com/jorisvink/kore.git"

  stable do
    url "https://kore.io/release/kore-1.2.3-release.tgz"
    sha256 "24f1a88f4ef3199d6585f821e1ef134bb448a1c9409a76d18fcccd4af940d32f"

    # 1.2.3 release doesn't respect user-passed CFLAGS nor does it store
    # information on where the OpenSSL headers used during build reside.
    # On El Capitan this results in `kore build test` failing.
    # Backport of https://github.com/jorisvink/kore/commit/4dff0b57ae6ed113d15b
    # https://github.com/jorisvink/kore/issues/70
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c86b133e2c137cd/kore/123findssl.diff"
      sha256 "70751661705993deab7d47c5505666738477f44f5b5bc1399b0ed9f30ebad6ec"
    end
  end

  bottle do
    sha256 "de46884ed40584d4d19654ad6c73ccbc363d8124c4d5146f7f9cb3a88e5bfda2" => :el_capitan
    sha256 "ce954b26de131904e013468ca9bca6fd87322be46d4698c2a16b6fb948b4ad6f" => :yosemite
    sha256 "19ad4950c7979c18ec09aef4433ec2ca09269f6669a8505f4ad438691b4252b0" => :mavericks
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl"].opt_include

    args = []

    args << "PGSQL=1" if build.with? "postgresql"

    system "make", "PREFIX=#{prefix}", "TASKS=1", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/kore", "create", "test"
    system "#{bin}/kore", "build", "test"
    system "#{bin}/kore", "clean", "test"
  end
end
