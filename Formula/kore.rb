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
      url "https://raw.githubusercontent.com/Homebrew/patches/c86b133e2c137cd/kore/123findssl.diff"
      sha256 "70751661705993deab7d47c5505666738477f44f5b5bc1399b0ed9f30ebad6ec"
    end
  end

  bottle do
    sha256 "acdd632ceba6698b1a52292a1f58f7b7adaefa6a677d138c3f16a1fb3ddd19e1" => :el_capitan
    sha256 "cba37916c300a8c35d9dab23dabdd2de0abb7eef560fa4f8328195f5543854fa" => :yosemite
    sha256 "42baed336207505fcbd03f95f5e3a842413569b987ef0f5e568350f81e66bfbd" => :mavericks
    sha256 "dbb9515b193dc3caa5ada4dd048d42ea8794ecab27d1420c051979ebe456276a" => :mountain_lion
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
