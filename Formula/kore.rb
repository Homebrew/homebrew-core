class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-3.1.0.tar.gz"
  sha256 "3f78fb03262046ffa036a7e112dbcbc45fbfca509a949b42f87a55da409f6595"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "ce63ce745b9ba194b9c70e087884fa0fb9931286cacae09b76e77c6899e44096" => :mojave
    sha256 "43818861d4e48631269eacdd0fac5ecfdc0e5127da6f7f12031447778b561e9a" => :high_sierra
    sha256 "cd067297b2aedfe47097dacf1bd02e3c2c57eb4af45a076c1e9ce33357e86b23" => :sierra
  end

  depends_on :macos => :sierra # needs clock_gettime

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
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
