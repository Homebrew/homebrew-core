class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-3.1.0.tar.gz"
  sha256 "3f78fb03262046ffa036a7e112dbcbc45fbfca509a949b42f87a55da409f6595"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    rebuild 1
    sha256 "946ce6d884b60a4a0d0914e0d46284ba079078f03a4daf17dcfc36bd9411800d" => :mojave
    sha256 "affd88a8f829810108c075e57f1e797302849a50c1d0948ecab8bec499ef7177" => :high_sierra
    sha256 "42c0c518094b65d21befa71388c37d8bf0f9f0fe1fe8f8b7f5509a258cb15fe0" => :sierra
  end

  depends_on :macos => :sierra # needs clock_gettime

  depends_on "openssl"

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl"].opt_include

    system "make", "PREFIX=#{prefix}", "TASKS=1"
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
